class SubskillEndorsement < ActiveRecord::Base
  self.table_name = 'subskill_endorsements'

  belongs_to :user_skill, class_name: 'SubskillUserSkill', foreign_key: 'subskill_user_skill_id'
  belongs_to :endorser, class_name: 'User', foreign_key: 'endorser_id'

  scope :active, -> { where(archived_at: nil) }

  validates :subskill_user_skill_id, presence: true
  validates :endorser_id, presence: true, uniqueness: { scope: :subskill_user_skill_id }
  validate :cannot_endorse_self

  private

  def cannot_endorse_self
    if user_skill && user_skill.user_id == endorser_id
      errors.add(:endorser_id, "cannot endorse your own skill")
    end
  end
end
