require_relative '../test_helper'

class SubskillEndorsementTest < ActiveSupport::TestCase
  include SubskillsTestHelper

  def setup
    @endorser = create_user("endorser1")
    @owner    = create_user("skill_owner")
    @skill    = SubskillSkill.create!(name: "Ruby on Rails", description: "Backend framework")
    @user_skill = SubskillUserSkill.create!(user: @owner, skill: @skill)
  end

  def test_endorsement_creation
    endorsement = SubskillEndorsement.create(
      user_skill: @user_skill,
      endorser:   @endorser
    )
    assert endorsement.valid?, endorsement.errors.full_messages.inspect
    assert_equal @endorser, endorsement.endorser
    assert_equal @user_skill, endorsement.user_skill
  end

  def test_duplicate_endorsement_is_invalid
    SubskillEndorsement.create!(user_skill: @user_skill, endorser: @endorser)

    duplicate = SubskillEndorsement.new(user_skill: @user_skill, endorser: @endorser)
    assert_not duplicate.valid?
    assert duplicate.errors[:endorser_id].any?
  end

  def test_cannot_endorse_own_skill
    self_endorsement = SubskillEndorsement.new(
      user_skill: @user_skill,
      endorser:   @owner
    )
    assert_not self_endorsement.valid?
    assert self_endorsement.errors[:endorser_id].any?
  end
end
