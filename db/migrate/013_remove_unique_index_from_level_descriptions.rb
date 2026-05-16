class RemoveUniqueIndexFromLevelDescriptions < ActiveRecord::Migration[5.2]
  def up
    remove_index :subskill_level_descriptions, name: 'idx_subskill_level_desc_unique'
  end

  def down
    add_index :subskill_level_descriptions, [:subskill_skill_id, :level], unique: true, name: 'idx_subskill_level_desc_unique'
  end
end
