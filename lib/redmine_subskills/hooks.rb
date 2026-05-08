module RedmineSubskills
  class Hooks < Redmine::Hook::ViewListener

    # CSS on every page
    def view_layouts_base_html_head(context = {})
      stylesheet_link_tag('subskills', plugin: 'redmine_subskills')
    end

    # Inject body class early so CSS can hide project menu on skill-matrix pages
    def view_layouts_base_body_top(context = {})
      return '' unless on_subskills_page?(context)
      '<script>document.body.classList.add("subskills-active-page");</script>'.html_safe
    end

    # Inline skill editor/viewer on /users/:id – left column, below issues
    def view_account_left_bottom(context = {})
      user = context[:user]
      return '' unless user && User.current.logged?

      skills      = SubskillSkill.active.ordered
      skill_ids   = skills.map(&:id)
      user_skills = SubskillUserSkill.where(user_id: user.id).index_by(&:subskill_skill_id)
      # {[skill_id, level] => description_text}
      level_descs = SubskillLevelDescription
                      .where(subskill_skill_id: skill_ids)
                      .each_with_object({}) { |d, h| h[[d.subskill_skill_id, d.level]] = d.description }
      can_edit    = (User.current == user) || User.current.admin?

      context[:controller].render_to_string(
        partial: 'subskills/my_account_skills',
        locals:  { user: user, skills: skills, user_skills: user_skills,
                   level_descs: level_descs, editable: false, can_edit: can_edit }
      )
    rescue => e
      Rails.logger.error "RedmineSubskills Hook error: #{e.message}"
      ''
    end

    private

    def on_subskills_page?(context)
      controller = context[:controller]
      return false unless controller
      controller.controller_name.start_with?('subskills')
    end
  end
end
