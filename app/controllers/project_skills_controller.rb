class ProjectSkillsController < ApplicationController
  menu_item :subskills
  before_action :find_project
  before_action :authorize, except: [:edit, :update]
  before_action :authorize_manage_subskills, only: [:edit, :update]
  before_action :find_or_init_skill_role

  # GET /projects/:project_id/skills
  def index
    @tree_rows = SubskillSkill.active.tree_rows
    @req_map   = @skill_role.requirements
                             .each_with_object({}) { |r, h| h[r.subskill_skill_id] = r.importance }

    leaf_ids = SubskillSkill.active.leaves.pluck(:id)
    @level_descs = SubskillLevelDescription
                     .where(subskill_skill_id: leaf_ids)
                     .each_with_object({}) do |d, h|
                       h[d.subskill_skill_id] ||= {}
                       h[d.subskill_skill_id][d.level] = d.description
                     end

    # Integrated best match
    @project_users = User.active.sort_by(&:name)
    all_us = SubskillUserSkill.where(user_id: @project_users.map(&:id)).includes(:endorsements)
    @user_skill_map = all_us.each_with_object({}) do |us, h|
      h[us.user_id] ||= {}
      h[us.user_id][us.subskill_skill_id] = { 
        level: us.level, 
        star: us.learn_priority.to_i > 0,
        endorse_count: us.endorsements.size
      }
    end
    req_max = @req_map.values.sum * 5
    @fit_scores = @project_users.map do |u|
      skill_levels = (@user_skill_map[u.id] || {}).transform_values { |v| v[:level] }
      pct = if req_max > 0
        raw = @req_map.sum { |sid, imp| [skill_levels[sid].to_i, 5].min * imp }
        (raw * 100.0 / req_max).round
      else
        0
      end
      { user: u, score: pct }
    end.sort_by { |x| -x[:score] }

    # Fetch roles for shown users in this project
    memberships = Member.where(project_id: @project.id, user_id: @project_users.map(&:id)).includes(:roles)
    @user_roles_map = memberships.each_with_object({}) do |m, h|
      h[m.user_id] = m.roles.sort_by(&:position).map(&:name).join(', ')
    end

    # Exclude users who have level=0 and no star for ANY skill
    # that is marked as "Erforderlich" (importance = 3)
    erforderlich_ids = @req_map.select { |_, imp| imp == 3 }.keys
    unless erforderlich_ids.empty?
      @fit_scores = @fit_scores.reject do |fs|
        user_skills = @user_skill_map[fs[:user].id] || {}
        erforderlich_ids.any? do |sid|
          entry = user_skills[sid]
          entry&.dig(:level).to_i == 0 && !entry&.dig(:star)
        end
      end
    end

    @can_manage_members = User.current.allowed_to?(:manage_members, @project)
    @project_roles = Role.givable.order(:name) if @can_manage_members
  end

  # GET /projects/:project_id/skills/best-match
  def best_match
    @users = User.active.sort_by(&:name)
    all_us = SubskillUserSkill.where(user_id: @users.map(&:id))
    user_skill_map = all_us.each_with_object({}) do |us, h|
      h[us.user_id] ||= {}
      h[us.user_id][us.subskill_skill_id] = us.level
    end

    @ranked_users = @users.map do |u|
      { user: u, score: @skill_role.fit_score(user_skill_map[u.id] || {}) }
    end.sort_by { |x| -x[:score] }
  end

  # GET /projects/:project_id/skills/edit
  def edit
    @tree_rows = SubskillSkill.active.tree_rows
    @req_map   = @skill_role.requirements
                             .each_with_object({}) { |r, h| h[r.subskill_skill_id] = r.importance }
  end

  # POST /projects/:project_id/skills
  def update
    @skill_role.update!(category: params[:sk_category].to_s) if params[:sk_category]

    skill_params = params[:skills] || {}

    # Remove old, re-insert
    @skill_role.requirements.destroy_all
    skill_params.each do |skill_id, importance|
      imp = importance.to_i
      next if imp == 0
      SubskillProjectRequirement.create!(
        project_id:        @project.id,
        subskill_skill_id: skill_id.to_i,
        importance:        imp
      )
    end

    flash[:notice] = 'Skill-Anforderungen gespeichert.'
    redirect_to project_skills_path(@project)
  end

  private

  def find_project
    @project = Project.find(params[:project_id])
  rescue ActiveRecord::RecordNotFound
    render_404
  end

  def find_or_init_skill_role
    @skill_role = SubskillProjectRole.find_or_create_by!(project_id: @project.id) do |r|
      r.category = ''
    end
  end

  def authorize_manage_subskills
    # Allow if user has explicit permission OR is a project manager/admin
    allowed = User.current.allowed_to?(:manage_subskills, @project) || 
              User.current.allowed_to?(:manage_project, @project) ||
              User.current.allowed_to?(:manage_members, @project)
    
    allowed ? true : deny_access
  end
end
