require_relative '../test_helper'

class SubskillSkillTest < ActiveSupport::TestCase
  def setup
    @root_skill = SubskillSkill.create!(name: "Programming", description: "General programming skills")
  end

  def test_skill_creation
    assert @root_skill.valid?
    assert_equal "Programming", @root_skill.name
  end

  def test_name_is_required
    invalid_skill = SubskillSkill.new(description: "No name")
    assert_not invalid_skill.valid?
    assert_not_nil invalid_skill.errors[:name]
  end

  def test_hierarchy
    child_skill = SubskillSkill.create!(name: "Ruby", description: "Ruby programming", parent_id: @root_skill.id)
    
    assert_equal @root_skill, child_skill.parent
    assert_includes @root_skill.children, child_skill
    assert child_skill.leaf?
    assert_not @root_skill.leaf?
  end

  def test_cannot_be_parent_of_itself
    @root_skill.parent_id = @root_skill.id
    assert_not @root_skill.valid?
    # Ensure there is a validation error for cyclic dependencies, assuming it's implemented.
    # If not implemented, this might fail, which is a good reminder to add such validation!
    assert_not_nil @root_skill.errors[:parent_id]
  end
end
