class SubskillsRolesController < ApplicationController
  before_action :require_login
  before_action { Thread.current[:sk_section] = true }
  after_action  { Thread.current[:sk_section] = nil  }

  # GET /subskills/rollen
  def index
    @roles      = SubskillRole.order(:position).includes(:requirements)
    @categories = @roles.map(&:category).uniq
    @skills     = SubskillSkill.active.ordered

    @users = User.active.to_a.select(&:visible?).sort_by(&:name)

    # user_id => { skill_id => level }
    all_us = SubskillUserSkill.where(user_id: @users.map(&:id))
    @user_skill_map = all_us.each_with_object({}) do |us, h|
      h[us.user_id] ||= {}
      h[us.user_id][us.subskill_skill_id] = us.level
    end

    # Pre-compute fit scores: role_id => { user_id => score }
    @fit_scores = @roles.each_with_object({}) do |role, h|
      h[role.id] = @users.each_with_object({}) do |user, uh|
        uh[user.id] = role.fit_score(@user_skill_map[user.id] || {})
      end
    end
  end

  # GET /subskills/rollen/:id
  def show
    @role   = SubskillRole.find(params[:id])
    @skills = SubskillSkill.active.ordered
    @req    = @role.requirements_map   # skill_id => importance

    @users  = User.active.to_a.select(&:visible?).sort_by(&:name)
    all_us  = SubskillUserSkill.where(user_id: @users.map(&:id))
    @user_skill_map = all_us.each_with_object({}) do |us, h|
      h[us.user_id] ||= {}
      h[us.user_id][us.subskill_skill_id] = us.level
    end

    # Sort users by fit score descending
    @users_with_scores = @users.map do |u|
      { user: u, score: @role.fit_score(@user_skill_map[u.id] || {}) }
    end.sort_by { |x| -x[:score] }
  end

  private

  def set_subskills_section
    Thread.current[:in_subskills_section] = true
  end
end
