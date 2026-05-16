class SubskillProjectRole < ActiveRecord::Base
  self.table_name = 'subskill_project_roles'

  belongs_to :project
  has_many   :requirements,
             class_name:  'SubskillProjectRequirement',
             foreign_key: :project_id,
             primary_key: :project_id,
             dependent:   :destroy

  IMPORTANCE = {
    0 => { label: '–',             color: '#eee' },
    1 => { label: :label_importance_helpful,     color: '#c8e6c9' },
    2 => { label: :label_importance_important,       color: '#fff176' },
    3 => { label: :label_importance_required,  color: '#ffab91' }
  }.freeze

  # { skill_id => importance }
  def requirements_map
    requirements.each_with_object({}) { |r, h| h[r.subskill_skill_id] = r.importance }
  end

  # Fit score 0–100 for a user given { skill_id => level }
  def fit_score(user_skills_map)
    req = requirements_map
    return 0 if req.empty?
    max   = req.values.sum * 5
    score = req.sum { |sid, imp| [user_skills_map[sid].to_i, 5].min * imp }
    (score * 100.0 / max).round
  end

  # Returns detailed fit info: [{ skill_name:, req_imp:, user_level: }]
  def fit_details(user_skills_map)
    requirements.includes(:skill).map do |r|
      {
        skill_name: r.skill&.name || '?',
        req_imp:    r.importance,
        user_level: user_skills_map[r.subskill_skill_id] || 0.0
      }
    end
  end

  def name
    project&.name || '–'
  end
end
