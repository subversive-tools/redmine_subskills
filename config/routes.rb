RedmineApp::Application.routes.draw do
  # Project-scoped skill module
  get  '/projects/:project_id/skills',            to: 'project_skills#index',      as: 'project_skills'
  get  '/projects/:project_id/skills/best-match', to: 'project_skills#best_match', as: 'project_skills_best_match'
  get  '/projects/:project_id/skills/edit',       to: 'project_skills#edit',       as: 'edit_project_skills'
  post '/projects/:project_id/skills',            to: 'project_skills#update',     as: 'update_project_skills'

  # Public: Team matrix overview
  get  '/subskills',                          to: 'subskills#index',               as: 'subskills'
  get  '/subskills/katalog',                  to: 'subskills#katalog',             as: 'subskills_katalog'

  # Public: Per-user skill profile (static for menu registration)
  get  '/subskills/me',                       to: 'subskills#my_skills_current',   as: 'my_skills_current_subskills'
  get  '/subskills/me/rollen',                to: 'subskills#my_rollen_current',   as: 'my_rollen_current_subskills'
  post '/subskills/me/skill',                 to: 'subskills#update_single_skill_current', as: 'update_my_skill_subskills'

  # Public: Per-user skill profile (parameterised, for cross-user viewing)
  get  '/subskills/user/:user_id',            to: 'subskills#my_skills',           as: 'user_skills_subskills'
  get  '/subskills/user/:user_id/rollen',     to: 'subskills#my_rollen',           as: 'my_rollen_subskills'
  post '/subskills/user/:user_id/skill',      to: 'subskills#update_single_skill', as: 'update_single_skill_subskills'
  post '/subskills/user/:user_id/endorse',    to: 'subskills#toggle_endorsement',  as: 'toggle_endorsement_subskills'

  # Admin: Skill catalog management
  get    '/subskills/admin',            to: 'subskills_admin#index',   as: 'subskills_admin_index'
  get    '/subskills/admin/new',        to: 'subskills_admin#new',     as: 'new_subskills_admin'
  post   '/subskills/admin',            to: 'subskills_admin#create',  as: 'subskills_admin_create'
  get    '/subskills/admin/:id/edit',   to: 'subskills_admin#edit',    as: 'edit_subskills_admin'
  patch  '/subskills/admin/:id',        to: 'subskills_admin#update',  as: 'subskills_admin'
  delete '/subskills/admin/:id',        to: 'subskills_admin#destroy'
  post   '/subskills/admin/:id/move',   to: 'subskills_admin#move',    as: 'move_subskills_admin'
  post   '/subskills/admin/reorder',    to: 'subskills_admin#reorder',            as: 'reorder_subskills_admin'
  post   '/subskills/admin/reorder_categories', to: 'subskills_admin#reorder_categories', as: 'reorder_categories_subskills_admin'
  post   '/subskills/admin/reparent',   to: 'subskills_admin#reparent',           as: 'reparent_subskills_admin'
  post   '/subskills/admin/seed',       to: 'subskills_admin#seed',    as: 'seed_subskills_admin_index'
  post   '/subskills/admin/import_csv', to: 'subskills_admin#import_csv', as: 'import_csv_subskills_admin_index'
  get    '/subskills/admin/export_csv', to: 'subskills_admin#export_csv', as: 'export_csv_subskills_admin_index'

  # Roles: fit-score matrix
  get '/subskills/rollen',     to: 'subskills_roles#index', as: 'subskills_roles'
  get '/subskills/rollen/:id', to: 'subskills_roles#show',  as: 'subskills_role'
end
