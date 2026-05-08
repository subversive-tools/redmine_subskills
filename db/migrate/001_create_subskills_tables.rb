class CreateSubskillsTables < ActiveRecord::Migration[5.2]
  def change
    # Skill definitions (managed by admin)
    create_table :subskill_skills do |t|
      t.string  :name,        null: false
      t.string  :category,    null: false
      t.text    :description
      t.integer :position,    default: 0
      t.boolean :active,      default: true
      t.timestamps
    end

    # User skill levels (0-5)
    create_table :subskill_user_skills do |t|
      t.references :user,  null: false, index: true
      t.references :subskill_skill, null: false, index: true
      t.integer    :level, null: false, default: 0
      t.text       :note
      t.timestamps
    end

    add_index :subskill_user_skills, [:user_id, :subskill_skill_id], unique: true
  end
end
