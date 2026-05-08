class AddProjectToRoles < ActiveRecord::Migration[5.2]
  def change
    add_column :subskill_roles, :project_id, :integer, null: true
    add_index  :subskill_roles, :project_id
  end
end
