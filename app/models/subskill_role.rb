class SubskillRole < ActiveRecord::Base
  self.table_name = 'subskill_roles'

  has_many :requirements, class_name: 'SubskillRoleRequirement',
                          foreign_key: 'subskill_role_id', dependent: :destroy

  IMPORTANCE = {
    0 => { label: '–',          color: '#eee' },
    1 => { label: :label_importance_helpful,  color: '#c8e6c9' },
    2 => { label: :label_importance_important,    color: '#fff176' },
    3 => { label: :label_importance_required, color: '#ffab91' }
  }.freeze

  DEFAULTS = [
    { name: 'Netzwerk & Firewall Owner',       category: 'A. System-Owner' },
    { name: 'Virtualization & Compute Owner',  category: 'A. System-Owner' },
    { name: 'Storage & Backup Owner',          category: 'A. System-Owner' },
    { name: 'IAM & Directory Owner',           category: 'A. System-Owner' },
    { name: 'Client-Management Owner',         category: 'A. System-Owner' },
    { name: 'Applikations-Owner',              category: 'A. System-Owner' },
    { name: 'IT-Security Officer',             category: 'B. Governance & IT-Management' },
    { name: 'IT-Compliance & Privacy Manager', category: 'B. Governance & IT-Management' },
    { name: 'Knowledge Manager',               category: 'B. Governance & IT-Management' },
    { name: 'IT-Asset & Procurement Manager',  category: 'B. Governance & IT-Management' },
    { name: 'IT-Portfolio Manager',            category: 'B. Governance & IT-Management' },
    { name: '1st-Level Dispatcher',            category: 'C. Operative Rollen' },
    { name: 'Incident Commander',              category: 'C. Operative Rollen' },
    { name: 'Release Manager',                 category: 'C. Operative Rollen' },
    { name: 'IT-Automation Architect',         category: 'C. Operative Rollen' },
    { name: 'Data Engineer',                   category: 'D. Research IT' },
    { name: 'Research Software Engineer',      category: 'D. Research IT' },
    { name: 'Lab IT Specialist',               category: 'D. Research IT' },
    { name: 'Service Owner',                   category: 'E. IT-Service-Management' },
  ].freeze

  # importance 1=hilfreich 2=wichtig 3=erforderlich
  REQUIREMENTS = {
    'Netzwerk & Firewall Owner' => {
      'Netzwerk & Firewall'               => 3,
      'IT-Security'                       => 2,
      'Linux / Server-Administration'     => 1,
      'Monitoring & Logging'              => 2,
      'IT-Projektmanagement'              => 2,
      'Kommunikation'                     => 2,
      'Selbstorganisation & Zeitmanagement' => 2,
      'Teamarbeit & Kollaboration'        => 1,
    },
    'Virtualization & Compute Owner' => {
      'Virtualisierung & Containerisierung' => 3,
      'Linux / Server-Administration'       => 2,
      'Storage & Backup Management'         => 2,
      'Cloud & DevOps'                      => 2,
      'Monitoring & Logging'                => 2,
      'IT-Projektmanagement'                => 2,
      'Kommunikation'                       => 2,
      'Selbstorganisation & Zeitmanagement' => 2,
      'Teamarbeit & Kollaboration'          => 1,
    },
    'Storage & Backup Owner' => {
      'Storage & Backup Management'         => 3,
      'Linux / Server-Administration'       => 2,
      'Monitoring & Logging'                => 2,
      'IT-Projektmanagement'                => 2,
      'Kommunikation'                       => 2,
      'Selbstorganisation & Zeitmanagement' => 2,
    },
    'IAM & Directory Owner' => {
      'IAM & Directory Services'            => 3,
      'IT-Security'                         => 2,
      'Linux / Server-Administration'       => 1,
      'IT-Projektmanagement'                => 2,
      'Kommunikation'                       => 2,
      'Selbstorganisation & Zeitmanagement' => 2,
    },
    'Client-Management Owner' => {
      'Helpdesk & User Support'             => 2,
      'IAM & Directory Services'            => 2,
      'IT-Projektmanagement'                => 2,
      'Kommunikation'                       => 3,
      'Selbstorganisation & Zeitmanagement' => 2,
      'Teamarbeit & Kollaboration'          => 2,
    },
    'Applikations-Owner' => {
      'Applikations- & Plattformentwicklung' => 3,
      'Datenbankadministration'              => 2,
      'Cloud & DevOps'                       => 2,
      'IT-Projektmanagement'                 => 3,
      'Kommunikation'                        => 2,
      'Teamarbeit & Kollaboration'           => 2,
      'Selbstorganisation & Zeitmanagement'  => 2,
    },
    'IT-Security Officer' => {
      'IT-Security'                          => 3,
      'IAM & Directory Services'             => 2,
      'Netzwerk & Firewall'                  => 2,
      'Monitoring & Logging'                 => 2,
      'Dokumentation & Wissensmanagement'    => 2,
      'IT-Projektmanagement'                 => 2,
      'Kommunikation'                        => 3,
      'Präsentation & Moderation'            => 2,
    },
    'IT-Compliance & Privacy Manager' => {
      'IT-Security'                          => 2,
      'Dokumentation & Wissensmanagement'    => 3,
      'IT-Projektmanagement'                 => 2,
      'Kommunikation'                        => 3,
      'Präsentation & Moderation'            => 2,
      'Selbstorganisation & Zeitmanagement'  => 2,
    },
    'Knowledge Manager' => {
      'Dokumentation & Wissensmanagement'    => 3,
      'Kommunikation'                        => 3,
      'Präsentation & Moderation'            => 2,
      'Selbstorganisation & Zeitmanagement'  => 3,
      'Teamarbeit & Kollaboration'           => 2,
      'Lernbereitschaft & Adaptabilität'     => 2,
    },
    'IT-Asset & Procurement Manager' => {
      'IT-Projektmanagement'                 => 2,
      'Dokumentation & Wissensmanagement'    => 2,
      'Kommunikation'                        => 2,
      'Selbstorganisation & Zeitmanagement'  => 3,
      'Teamarbeit & Kollaboration'           => 1,
    },
    'IT-Portfolio Manager' => {
      'IT-Projektmanagement'                 => 3,
      'Kommunikation'                        => 3,
      'Führungskompetenz'                    => 2,
      'Präsentation & Moderation'            => 3,
      'Selbstorganisation & Zeitmanagement'  => 3,
      'Teamarbeit & Kollaboration'           => 2,
    },
    '1st-Level Dispatcher' => {
      'Helpdesk & User Support'              => 3,
      'Kommunikation'                        => 3,
      'Selbstorganisation & Zeitmanagement'  => 3,
      'Konfliktfähigkeit'                    => 2,
      'Teamarbeit & Kollaboration'           => 2,
    },
    'Incident Commander' => {
      'Monitoring & Logging'                 => 3,
      'IT-Security'                          => 2,
      'Linux / Server-Administration'        => 2,
      'Netzwerk & Firewall'                  => 1,
      'Kommunikation'                        => 3,
      'Führungskompetenz'                    => 3,
      'Konfliktfähigkeit'                    => 2,
      'Selbstorganisation & Zeitmanagement'  => 2,
    },
    'Release Manager' => {
      'Cloud & DevOps'                       => 2,
      'IT-Projektmanagement'                 => 3,
      'Dokumentation & Wissensmanagement'    => 2,
      'Kommunikation'                        => 3,
      'Teamarbeit & Kollaboration'           => 2,
      'Selbstorganisation & Zeitmanagement'  => 3,
    },
    'IT-Automation Architect' => {
      'Python / Scripting'                   => 3,
      'Cloud & DevOps'                       => 3,
      'Linux / Server-Administration'        => 2,
      'Monitoring & Logging'                 => 2,
      'Lernbereitschaft & Adaptabilität'     => 3,
      'Teamarbeit & Kollaboration'           => 2,
      'Kommunikation'                        => 2,
    },
    'Data Engineer' => {
      'Data Engineering & Analytics'         => 3,
      'Python / Scripting'                   => 3,
      'Datenbankadministration'              => 2,
      'Linux / Server-Administration'        => 2,
      'Cloud & DevOps'                       => 2,
      'Kommunikation'                        => 2,
      'Teamarbeit & Kollaboration'           => 2,
    },
    'Research Software Engineer' => {
      'Applikations- & Plattformentwicklung' => 3,
      'Python / Scripting'                   => 3,
      'Data Engineering & Analytics'         => 2,
      'Datenbankadministration'              => 2,
      'Kommunikation'                        => 2,
      'Teamarbeit & Kollaboration'           => 2,
      'Lernbereitschaft & Adaptabilität'     => 2,
    },
    'Lab IT Specialist' => {
      'Linux / Server-Administration'        => 2,
      'Helpdesk & User Support'              => 2,
      'Netzwerk & Firewall'                  => 1,
      'Kommunikation'                        => 2,
      'Selbstorganisation & Zeitmanagement'  => 2,
      'Teamarbeit & Kollaboration'           => 2,
    },
    'Service Owner' => {
      'IT-Projektmanagement'                 => 3,
      'Helpdesk & User Support'              => 2,
      'Dokumentation & Wissensmanagement'    => 2,
      'Kommunikation'                        => 3,
      'Führungskompetenz'                    => 2,
      'Präsentation & Moderation'            => 2,
      'Teamarbeit & Kollaboration'           => 2,
      'Selbstorganisation & Zeitmanagement'  => 2,
    },
  }.freeze

  def self.seed_defaults!
    DEFAULTS.each_with_index do |attrs, i|
      role = find_or_create_by!(name: attrs[:name]) do |r|
        r.category = attrs[:category]
        r.position = i
      end

      skill_reqs = REQUIREMENTS[attrs[:name]] || {}
      skill_reqs.each do |skill_name, importance|
        skill = SubskillSkill.find_by(name: skill_name)
        next unless skill
        SubskillRoleRequirement.find_or_create_by!(
          subskill_role_id:  role.id,
          subskill_skill_id: skill.id
        ) { |r| r.importance = importance }
      end
    end
  end

  # Returns { skill_id => importance } for this role
  def requirements_map
    requirements.each_with_object({}) do |r, h|
      h[r.subskill_skill_id] = r.importance
    end
  end

  # Fit score (0–100) for a user given their skill levels
  def fit_score(user_skills_map)
    req = requirements_map
    return 0 if req.empty?
    max   = req.values.sum * 5
    score = req.sum { |sid, imp| [user_skills_map[sid] || 0, 5].min * imp }
    (score * 100.0 / max).round
  end

  # Returns detailed fit info: [{ skill_name:, req_imp:, user_level: }]
  def fit_details(user_skills_map)
    requirements.includes(:skill).map do |r|
      {
        skill_name: r.skill.name,
        req_imp:    r.importance,
        user_level: user_skills_map[r.subskill_skill_id] || 0.0
      }
    end
  end
end
