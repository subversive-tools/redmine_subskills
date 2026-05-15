class AddArchivedAtToSubskillEndorsements < ActiveRecord::Migration[5.2]
  def change
    unless column_exists?(:subskill_endorsements, :archived_at)
      add_column :subskill_endorsements, :archived_at, :datetime
    end
    unless index_exists?(:subskill_endorsements, :archived_at)
      add_index :subskill_endorsements, :archived_at
    end
  end
end
