class AddSkillHierarchy < ActiveRecord::Migration[5.2]
  def change
    add_column :subskill_skills, :parent_id, :integer
    add_column :subskill_skills, :weight,    :decimal, precision: 5, scale: 2, default: 1.0, null: false
    add_index  :subskill_skills, :parent_id
  end
end
