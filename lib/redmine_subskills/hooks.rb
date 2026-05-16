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

      tree_rows   = SubskillSkill.active.tree_rows
      all_ids     = tree_rows.map { |r| r[:skill].id }
      user_skills = SubskillUserSkill.where(user_id: user.id).index_by(&:subskill_skill_id)
      score_map   = SubskillSkill.active.compute_scores_for_user(user.id)
      level_descs = SubskillLevelDescription
                      .where(subskill_skill_id: all_ids)
                      .each_with_object({}) { |d, h| h[[d.subskill_skill_id, d.level]] = d.description }
            can_edit    = (User.current == user) || User.current.admin?
      
      my_endorsements = []
      if user_skills.any? && User.current != user
        my_endorsements = SubskillEndorsement.where(
          subskill_user_skill_id: user_skills.values.map(&:id),
          endorser_id: User.current.id
        ).pluck(:subskill_user_skill_id)
      end

      context[:controller].render_to_string(
        partial: 'subskills/my_account_skills',
        locals:  { user: user, tree_rows: tree_rows, user_skills: user_skills,
                                      score_map: score_map, level_descs: level_descs,
                   editable: false, can_edit: can_edit, my_endorsements: my_endorsements }
      )
    rescue => e
      Rails.logger.error "RedmineSubskills Hook error: #{e.message}"
      ''
    end

    # Member table in Project Settings
    def view_projects_settings_members_table_header(context = {})
      project = context[:project]
      return '' unless project&.module_enabled?(:subskills)
      '<script>
        (function() {
          console.log("RedmineSubskills: Header script running");
          const thead = document.querySelector(".members thead tr");
          if (thead && !document.getElementById("sk-th-fit")) {
            const roleLabels = ["Rollen", "Rolle", "Roles", "Role"];
            const ths = Array.from(thead.querySelectorAll("th"));
            const rolesTh = ths.find(el => roleLabels.includes(el.textContent.trim()));
            
            const th = document.createElement("th");
            th.id = "sk-th-fit";
            th.textContent = "#{I18n.t(:label_skill_match, default: 'Skill-Passung')}";
            
            if (rolesTh && rolesTh.nextElementSibling) {
              thead.insertBefore(th, rolesTh.nextElementSibling);
            } else {
              const btnTh = thead.querySelector("th.buttons");
              if (btnTh) thead.insertBefore(th, btnTh);
              else thead.appendChild(th);
            }
          }
        })();
      </script>'.html_safe
    end

    def view_projects_settings_members_table_row(context = {})
      project = context[:project]
      return '' unless project&.module_enabled?(:subskills)
      context[:controller].render_to_string(
        partial: 'hooks/subskills/members_table_row',
        locals: context
      )
    rescue => e
      Rails.logger.error "RedmineSubskills Row Hook error: #{e.message}"
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
