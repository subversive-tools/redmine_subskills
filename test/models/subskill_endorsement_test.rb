require_relative '../test_helper'

class SubskillEndorsementTest < ActiveSupport::TestCase
  include SubskillsTestHelper

  def setup
    @user1 = create_user("endorser1")
    @user2 = create_user("endorser2")
    @target = create_user("target")
    @skill = SubskillSkill.create!(name: "Ruby on Rails", description: "Backend framework")
  end

  def test_endorsement_creation
    endorsement = SubskillEndorsement.create(
      endorser: @user1,
      user: @target,
      skill: @skill
    )
    assert endorsement.valid?
    assert_equal @user1, endorsement.endorser
  end

  def test_duplicate_endorsement_should_be_invalid
    SubskillEndorsement.create!(
      endorser: @user1,
      user: @target,
      skill: @skill
    )
    
    duplicate = SubskillEndorsement.new(
      endorser: @user1,
      user: @target,
      skill: @skill
    )
    assert_not duplicate.valid?
    assert_includes duplicate.errors[:endorser_id], "hat diesen Skill bereits bestätigt"
  end

  def test_can_endorse_self_is_invalid
    endorsement = SubskillEndorsement.new(
      endorser: @target,
      user: @target,
      skill: @skill
    )
    assert_not endorsement.valid?
    assert_includes endorsement.errors[:base], "Man kann sich nicht selbst bestätigen."
  end
end
