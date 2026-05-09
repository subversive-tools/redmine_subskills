class SubskillsController < ApplicationController
  before_action :require_login
  before_action  { Thread.current[:sk_section] = true  }
  after_action   { Thread.current[:sk_section] = nil   }
  before_action :find_target_user,   only: [:my_skills, :my_rollen, :update_single_skill]
  before_action :use_current_user,   only: [:my_skills_current, :my_rollen_current,
                                            :update_single_skill_current]

  # GET /subskills – Team Skill-Matrix (leaf skills only)
  def index
    @tree_rows  = SubskillSkill.active.tree_rows
    @leaf_skills = SubskillSkill.active.leaves.order(:position, :name)
    @users       = User.active.sort_by(&:name)

    all_user_skills = SubskillUserSkill.where(user_id: @users.map(&:id))
    @matrix = all_user_skills.each_with_object({}) do |us, h|
      h[us.user_id] ||= {}
      h[us.user_id][us.subskill_skill_id] = { level: us.level, learn_priority: us.learn_priority }
    end
  end

  # GET /subskills/katalog
  def katalog
    @tree_rows = SubskillSkill.active.tree_rows
    @roles     = SubskillRole.order(:position).includes(:requirements)
    @role_cats = @roles.map(&:category).uniq
  end

  # GET /subskills/me  → current user
  def my_skills_current
    @target_user = User.current
    @tree_rows   = SubskillSkill.active.tree_rows
    @score_map   = SubskillSkill.active.compute_scores_for_user(@target_user.id)
    @user_skills = SubskillUserSkill.where(user_id: @target_user.id).index_by(&:subskill_skill_id)
    @editable    = true

    all_leaf_ids = SubskillSkill.active.leaves.pluck(:id)
    descs = SubskillLevelDescription.where(subskill_skill_id: all_leaf_ids)
    @level_descriptions = descs.each_with_object({}) do |d, h|
      h[d.subskill_skill_id] ||= {}
      h[d.subskill_skill_id][d.level] = d.description
    end

    render action: :my_skills
  end

  # GET /subskills/me/rollen  → current user
  def my_rollen_current
    @target_user = User.current
    @roles       = SubskillRole.order(:position).includes(:requirements)
    @role_cats   = @roles.map(&:category).uniq

    user_skills = SubskillUserSkill.where(user_id: @target_user.id)
    @skill_map  = user_skills.each_with_object({}) { |us, h| h[us.subskill_skill_id] = us.level }
    @scores     = @roles.map { |r| { role: r, score: r.fit_score(@skill_map) } }
                        .sort_by { |x| -x[:score] }

    render action: :my_rollen
  end

  # POST /subskills/me/skill  → current user
  def update_single_skill_current
    @target_user = User.current
    update_single_skill
  end

  # GET /subskills/user/:user_id
  def my_skills
    @skills      = SubskillSkill.active.ordered
    @user_skills = SubskillUserSkill.where(user_id: @target_user.id)
                                    .index_by(&:subskill_skill_id)
    @editable    = (User.current == @target_user) || User.current.admin?

    descs = SubskillLevelDescription.where(subskill_skill_id: @skills.map(&:id))
    @level_descriptions = descs.each_with_object({}) do |d, h|
      h[d.subskill_skill_id] ||= {}
      h[d.subskill_skill_id][d.level] = d.description
    end
  end

  # GET /subskills/user/:user_id/rollen
  def my_rollen
    @roles     = SubskillRole.order(:position).includes(:requirements)
    @role_cats = @roles.map(&:category).uniq

    user_skills = SubskillUserSkill.where(user_id: @target_user.id)
    @skill_map  = user_skills.each_with_object({}) { |us, h| h[us.subskill_skill_id] = us.level }

    @scores = @roles.map do |role|
      { role: role, score: role.fit_score(@skill_map) }
    end.sort_by { |x| -x[:score] }
  end

  # POST /subskills/user/:user_id/skill  (AJAX auto-save)
  def update_single_skill
    unless User.current == @target_user || User.current.admin?
      render json: { ok: false, error: 'Unauthorized' }, status: 403
      return
    end

    skill_id = params[:skill_id].to_i
    us = SubskillUserSkill.find_or_initialize_by(
      user_id: @target_user.id,
      subskill_skill_id: skill_id
    )

    # Only update fields that were explicitly sent
    us.level          = params[:level].to_i.clamp(0, 5)          if params.key?(:level)
    us.learn_priority = params[:learn_priority].to_i.clamp(0, 1) if params.key?(:learn_priority)
    us.save!

    render json: { ok: true }
  rescue => e
    render json: { ok: false, error: e.message }, status: 422
  end

  private

  def use_current_user
    @target_user = User.current
  end

  def find_target_user
    @target_user = params[:user_id] ? User.find(params[:user_id]) : User.current
  rescue ActiveRecord::RecordNotFound
    render_404
  end
end
