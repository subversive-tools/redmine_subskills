class SubskillUserSkill < ActiveRecord::Base
  self.table_name = 'subskill_user_skills'

  belongs_to :user
  belongs_to :skill, class_name: 'SubskillSkill', foreign_key: 'subskill_skill_id'

  has_many :endorsements, class_name: 'SubskillEndorsement', foreign_key: 'subskill_user_skill_id', dependent: :destroy

  LEVELS = {
    0 => { color: '#eee' },
    1 => { color: '#90b8d8' },
    2 => { color: '#5b9ec9' },
    3 => { color: '#2e78b7' },
    4 => { color: '#1a5c99' },
    5 => { color: '#0d3d6b' }
  }.freeze

  def self.level_label(level)
    lines = (Setting.plugin_redmine_subskills['default_level_labels'] || "").split("\n").map(&:strip)
    lines[level].presence || "Level #{level}"
  end

  validates :user_id, presence: true
  validates :subskill_skill_id, presence: true, uniqueness: { scope: :user_id }
  validates :level, numericality: { greater_than_or_equal_to: 0, less_than_or_equal_to: 20 }
  validates :learn_priority, inclusion: { in: 0..3 }

  before_save :archive_endorsements_on_level_change, if: :level_changed?

  # Returns all skill levels for a given user, filling gaps with 0
  def self.levels_for(user, skills)
    existing = where(user_id: user.id, subskill_skill_id: skills.map(&:id))
    skills.each_with_object({}) do |s, h|
      us = existing.find { |e| e.subskill_skill_id == s.id }
      h[s.id] = us ? us.level : 0
    end
  end

  def level_label
    self.class.level_label(level)
  end

  private

  def archive_endorsements_on_level_change
    # Mark all currently active endorsements as archived
    endorsements.where(archived_at: nil).update_all(archived_at: Time.current)
  end
end
