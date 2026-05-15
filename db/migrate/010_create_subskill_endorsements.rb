class CreateSubskillEndorsements < ActiveRecord::Migration[5.2]
  def change
    create_table :subskill_endorsements do |t|
      t.integer :subskill_user_skill_id, null: false
      t.integer :endorser_id, null: false

      t.timestamps
    end

    add_index :subskill_endorsements, :subskill_user_skill_id
    add_index :subskill_endorsements, :endorser_id
    add_index :subskill_endorsements, [:subskill_user_skill_id, :endorser_id], unique: true, name: 'index_endorsements_on_user_skill_and_endorser'
  end
end
