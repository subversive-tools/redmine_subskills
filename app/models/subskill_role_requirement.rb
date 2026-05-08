class SubskillRoleRequirement < ActiveRecord::Base
  self.table_name = 'subskill_role_requirements'

  belongs_to :role,  class_name: 'SubskillRole',  foreign_key: 'subskill_role_id'
  belongs_to :skill, class_name: 'SubskillSkill', foreign_key: 'subskill_skill_id'

  validates :importance, inclusion: { in: 0..3 }
end
