class AddLevelsConfigToSubskills < ActiveRecord::Migration[5.2]
  def change
    add_column :subskill_skills, :levels_count, :integer
    add_column :subskill_level_descriptions, :label, :string
  end
end
