class AddLearnPriority < ActiveRecord::Migration[5.2]
  def change
    add_column :subskill_user_skills, :learn_priority, :integer, default: 0, null: false
    # Migrate old boolean data: want_to_learn=true → learn_priority=1
    execute "UPDATE subskill_user_skills SET learn_priority = 1 WHERE want_to_learn = true"
    remove_column :subskill_user_skills, :want_to_learn
  end
end
