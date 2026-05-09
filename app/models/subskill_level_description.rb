class SubskillLevelDescription < ActiveRecord::Base
  self.table_name = 'subskill_level_descriptions'

  belongs_to :skill, class_name: 'SubskillSkill', foreign_key: 'subskill_skill_id', inverse_of: :level_descriptions

  validates :level, inclusion: { in: 1..5 }
  validates :subskill_skill_id, presence: true
end
