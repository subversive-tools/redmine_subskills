class CreateRoleRequirements < ActiveRecord::Migration[5.2]
  def change
    create_table :subskill_roles do |t|
      t.string  :name,     null: false
      t.string  :category, null: false, default: ''
      t.integer :position, default: 0
    end
    add_index :subskill_roles, :name, unique: true

    create_table :subskill_role_requirements do |t|
      t.references :subskill_role,  null: false, index: true
      t.references :subskill_skill, null: false, index: true
      t.integer :importance, default: 0, null: false  # 0=n/a 1=hilfreich 2=wichtig 3=erforderlich
    end
    add_index :subskill_role_requirements, [:subskill_role_id, :subskill_skill_id],
              unique: true, name: 'idx_role_skill_unique'
  end
end
