class AddSkillLevelsAndWantToLearn < ActiveRecord::Migration[5.2]
  def change
    # Level descriptions per skill (1-5)
    create_table :subskill_level_descriptions do |t|
      t.references :subskill_skill, null: false, index: true
      t.integer    :level,          null: false
      t.text       :description
    end
    add_index :subskill_level_descriptions, [:subskill_skill_id, :level], unique: true,
              name: 'idx_subskill_level_desc_unique'

    # want_to_learn flag on user skills
    add_column :subskill_user_skills, :want_to_learn, :boolean, default: false, null: false
  end
end
