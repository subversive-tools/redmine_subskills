class SubskillUserSkill < ActiveRecord::Base
  self.table_name = 'subskill_user_skills'

  LEVELS = {
    0 => { label: 'Kein Wissen', color: '#e0e0e0' },
    1 => { label: 'Grundkenntnisse',  color: '#90caf9' },
    2 => { label: 'Anwender',         color: '#42a5f5' },
    3 => { label: 'Fortgeschritten',  color: '#1e88e5' },
    4 => { label: 'Experte',          color: '#1565c0' },
    5 => { label: 'Spezialist',       color: '#0d47a1' }
  }.freeze

  belongs_to :user
  belongs_to :skill, class_name: 'SubskillSkill', foreign_key: 'subskill_skill_id'

  validates :user_id, presence: true
  validates :subskill_skill_id, presence: true, uniqueness: { scope: :user_id }
  validates :level, inclusion: { in: 0..5 }
  validates :learn_priority, inclusion: { in: 0..3 }

  # Returns all skill levels for a given user, filling gaps with 0
  def self.levels_for(user, skills)
    existing = where(user_id: user.id, subskill_skill_id: skills.map(&:id))
                 .index_by(&:subskill_skill_id)
    skills.map { |s| existing[s.id]&.level || 0 }
  end

  def level_label
    LEVELS[level]&.fetch(:label, '')
  end
end
