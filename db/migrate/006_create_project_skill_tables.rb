class CreateProjectSkillTables < ActiveRecord::Migration[5.2]
  def change
    # Marks a Redmine project as a "role project" and stores its category
    create_table :subskill_project_roles do |t|
      t.integer :project_id, null: false
      t.string  :category,   null: false, default: ''
      t.timestamps
    end
    add_index :subskill_project_roles, :project_id, unique: true

    # Skill requirements per project (replaces subskill_role_requirements)
    create_table :subskill_project_requirements do |t|
      t.integer :project_id,        null: false
      t.integer :subskill_skill_id,  null: false
      t.integer :importance,         null: false, default: 1  # 1=hilfreich 2=wichtig 3=erforderlich
      t.timestamps
    end
    add_index :subskill_project_requirements, [:project_id, :subskill_skill_id], unique: true,
              name: 'idx_proj_req_unique'
    add_index :subskill_project_requirements, :project_id
    add_index :subskill_project_requirements, :subskill_skill_id
  end
end
