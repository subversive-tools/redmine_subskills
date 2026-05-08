class ProjectSkillsController < ApplicationController
  menu_item :subskills
  before_action :find_project
  before_action :authorize
  before_action :find_or_init_skill_role

  # GET /projects/:project_id/skills
  def index
    @requirements    = @skill_role.requirements.includes(:skill)
                                  .sort_by { |r| [r.skill.category.to_s, r.skill.position.to_i] }
    @skills_by_cat   = SubskillSkill.active.ordered.group_by(&:category)
    @req_map         = @requirements.each_with_object({}) { |r, h| h[r.subskill_skill_id] = r.importance }
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
    @skills_by_cat = SubskillSkill.active.ordered.group_by(&:category)
    @req_map       = @skill_role.requirements
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
end
