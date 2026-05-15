Redmine::Plugin.register :redmine_subskills do
  name        'Redmine Subskills'
  author      'Stefan Mischke'
  description 'Skill Management and Role matrix for Redmine'
  version     '0.3.0'

  # ── Projektmodul "skills" ────────────────────────────────────
  project_module :subskills do
    permission :view_subskills,
               { project_skills: [:index, :best_match] },
               public: true

    permission :manage_subskills,
               { project_skills: [:edit, :update] }
  end

  # Reiter im Projektmenü
  menu :project_menu, :subskills,
       { controller: 'project_skills', action: 'index' },
       caption: 'Skills',
       param: :project_id

  # ── Skills-Tabs im #main-menu – nur auf /subskills/* ─────────
  sk_section = Proc.new { |*| Thread.current[:sk_section] == true }

  menu :application_menu, :sk_katalog,
       { controller: 'subskills', action: 'katalog' },
       caption: :label_roles_and_skills,
       if: sk_section

  menu :application_menu, :sk_my_skills,
       { controller: 'subskills', action: 'my_skills_current' },
       caption: :label_my_skills,
       if: sk_section

  menu :application_menu, :sk_my_rollen,
       { controller: 'subskills', action: 'my_rollen_current' },
       caption: :label_my_role_match,
       if: sk_section

  menu :application_menu, :sk_matrix,
       { controller: 'subskills', action: 'index' },
       caption: :label_skill_matrix_team,
       if: sk_section

  menu :application_menu, :sk_rollen_team,
       { controller: 'subskills_roles', action: 'index' },
       caption: :label_team_role_match,
       if: sk_section

  # ── Admin-Menü ───────────────────────────────────────────────
  menu :admin_menu, :subskills_admin,
       { controller: 'subskills_admin', action: 'index' },
       caption: :label_subskills,
       before:  :trackers,
       html: { class: 'icon' }
end

require_relative 'lib/redmine_subskills/hooks'

ActiveSupport::Reloader.to_prepare do
  # no-op
end
