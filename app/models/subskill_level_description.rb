class SubskillLevelDescription < ActiveRecord::Base
  self.table_name = 'subskill_level_descriptions'

  belongs_to :skill, class_name: 'SubskillSkill', foreign_key: 'subskill_skill_id', inverse_of: :level_descriptions

  validates :level, numericality: { greater_than_or_equal_to: 1, less_than_or_equal_to: 20 }
end
