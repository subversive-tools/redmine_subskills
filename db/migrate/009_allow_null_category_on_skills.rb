class AllowNullCategoryOnSkills < ActiveRecord::Migration[5.2]
  def up
    change_column_default :subskill_skills, :category, from: nil, to: ''
    change_column_null    :subskill_skills, :category, true
    # Ensure existing NULLs become empty string
    SubskillSkill.where(category: nil).update_all(category: '')
  end

  def down
    SubskillSkill.where(category: [nil, '']).update_all(category: 'Allgemein')
    change_column_null    :subskill_skills, :category, false
    change_column_default :subskill_skills, :category, from: '', to: nil
  end
end
