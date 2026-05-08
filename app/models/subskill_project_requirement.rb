class SubskillProjectRequirement < ActiveRecord::Base
  self.table_name = 'subskill_project_requirements'

  belongs_to :project
  belongs_to :skill, class_name: 'SubskillSkill', foreign_key: :subskill_skill_id

  validates :project_id,       presence: true
  validates :subskill_skill_id, presence: true
  validates :importance, inclusion: { in: 0..3 }
  validates :subskill_skill_id, uniqueness: { scope: :project_id }
end
