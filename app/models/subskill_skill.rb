class SubskillSkill < ActiveRecord::Base
  self.table_name = 'subskill_skills'

  has_many :user_skills, class_name: 'SubskillUserSkill', foreign_key: 'subskill_skill_id', dependent: :destroy
  has_many :level_descriptions, class_name: 'SubskillLevelDescription', foreign_key: 'subskill_skill_id', dependent: :destroy
  has_many :role_requirements, class_name: 'SubskillRoleRequirement', foreign_key: 'subskill_skill_id', dependent: :destroy
  has_many :project_requirements, class_name: 'SubskillProjectRequirement', foreign_key: 'subskill_skill_id', dependent: :destroy

  belongs_to :parent, class_name: 'SubskillSkill', optional: true
  has_many :children, class_name: 'SubskillSkill', foreign_key: 'parent_id', dependent: :destroy

  accepts_nested_attributes_for :level_descriptions, allow_destroy: true

  validates :name,     presence: true, uniqueness: true
  validates :category, presence: true
  validate  :prevent_self_parenting
  validate  :prevent_rated_parenting

  scope :active, -> { where(active: true) }
  scope :roots,  -> { where(parent_id: nil) }
  scope :leaves, -> { where.not(id: SubskillSkill.select(:parent_id).where.not(parent_id: nil)) }

  # Default skills to seed
  DEFAULTS = [
    { name: 'Linux / Server-Administration',            category: 'System-Infrastruktur' },
    { name: 'Netzwerk & Firewall',                      category: 'System-Infrastruktur' },
    { name: 'Virtualisierung & Containerisierung',      category: 'System-Infrastruktur' },
    { name: 'Storage & Backup Management',              category: 'System-Infrastruktur' },
    { name: 'IAM & Directory Services',                 category: 'System-Infrastruktur' },
    { name: 'Cloud & DevOps',                           category: 'Cloud & Entwicklung' },
    { name: 'Python / Scripting',                       category: 'Cloud & Entwicklung' },
    { name: 'Applikations- & Plattformentwicklung',     category: 'Cloud & Entwicklung' },
    { name: 'Datenbankadministration',                  category: 'Cloud & Entwicklung' },
    { name: 'Data Engineering & Analytics',             category: 'Cloud & Entwicklung' },
    { name: 'IT-Security',                              category: 'Sicherheit & Monitoring' },
    { name: 'Monitoring & Logging',                     category: 'Sicherheit & Monitoring' },
    { name: 'Helpdesk & User Support',                  category: 'Service & Support' },
    { name: 'Dokumentation & Wissensmanagement',        category: 'Service & Support' },
    { name: 'IT-Projektmanagement',                     category: 'Management & Organisation' },
    { name: 'Kommunikation',                            category: 'Sozial- & Selbstkompetenz' },
    { name: 'Teamarbeit & Kollaboration',               category: 'Sozial- & Selbstkompetenz' },
    { name: 'Selbstorganisation & Zeitmanagement',      category: 'Sozial- & Selbstkompetenz' },
    { name: 'Konfliktfähigkeit',                        category: 'Sozial- & Selbstkompetenz' },
    { name: 'Lernbereitschaft & Adaptabilität',         category: 'Sozial- & Selbstkompetenz' },
    { name: 'Führungskompetenz',                        category: 'Sozial- & Selbstkompetenz' },
    { name: 'Präsentation & Moderation',                category: 'Sozial- & Selbstkompetenz' },
  ].freeze

  LEVEL_TEXTS = {
    'Linux / Server-Administration' => [
      'Grundbefehle & Navigation (ls, cd), Dateisystem-Struktur verstehen, Logfiles lesen',
      'Benutzer- & Diensteverwaltung (systemd), Paketmanagement, Standard-Konfigurationen',
      'Selbstständige Wartung, Backup-Integration, Netzwerk-Grundlagen, Troubleshooting',
      'Automatisierung (Scripting), Security-Hardening, Performance-Optimierung, Kernel-Parameter',
      'Design komplexer Server-Landschaften, Architektur-Entscheidungen, High-Availability'
    ],
    'Netzwerk & Firewall' => [
      'IP-Grundlagen (IPv4/v6, Subnetting), DNS-Verständnis, Tools wie ping/traceroute',
      'Konfiguration einfacher VLANs, Standard-Firewallregeln, WLAN-Basis-Setup',
      'Implementierung von Netzwerk-Segmenten, Routing-Steuerung, VPN-Konfiguration',
      'Design komplexer Topologien (BGP/OSPF), Advanced Firewall Policies, QoS',
      'Gesamtheitliche Netzwerk-Architektur, Enterprise-Security-Design, SDN-Konzepte'
    ],
    'Virtualisierung & Containerisierung' => [
      'Konzepte von VMs & Containern verstehen, Start/Stop von Standard-Instanzen',
      'Erstellung einfacher Docker-Images, Docker-Compose, Basis-Verwaltung von VMs',
      'Administration von Clustern (Proxmox/vSphere), Ressourcen-Management, Snapshots',
      'Orchestrierung (Kubernetes Basis), Infrastructure as Code (IaC), Performance-Tuning',
      'Design hochverfügbarer Cloud-Native-Infrastrukturen, K8s-Architektur, Storage-Backends'
    ],
    'Storage & Backup Management' => [
      'Laufwerke einbinden, RAID-Grundlagen verstehen, bestehende Backups bedienen',
      'NFS/SMB-Shares verwalten, Einrichtung einfacher Backup-Jobs (Veeam, PBS)',
      'Betrieb von Storage-Clustern, Kapazitätsplanung, Recovery-Tests, Monitoring',
      'Storage-Tiering, Replikations-Szenarien, Optimierung für IOPS-kritische Systeme',
      'Enterprise-Storage-Architektur, BCM-Strategien, Disaster Recovery Gesamtdesign'
    ],
    'IAM & Directory Services' => [
      'Benutzeranlage, Passwort-Resets, Gruppenrechte-Verständnis',
      'Administration von AD/LDAP, Konfiguration von Gruppenrichtlinien (GPOs)',
      'Integration von Systemen in IAM-Lösungen, SSO-Grundlagen (OAuth/SAML)',
      'Identity Federation (SWITCHaai), Role-Based Access Control (RBAC) Design',
      'Architektur von Identity-Landschaften, Zero-Trust-Konzepte, Lifecycle-Management'
    ],
    'Cloud & DevOps' => [
      'Verständnis Cloud-Konzepte (IaaS/PaaS), Nutzung bestehender CI-Pipelines',
      'Basis-Automatisierung, Git-Workflows, Container-Deployments',
      'Konfiguration von CI/CD-Pipelines, Cloud-Ressourcen-Management',
      'IaC (Terraform/Ansible), Advanced Orchestration, Monitoring-Integration',
      'Entwurf von Platform-Engineering-Strategien, Multi-Cloud-Architekturen, GitOps'
    ],
    'Python / Scripting' => [
      'Skripte lesen & kleine Anpassungen vornehmen, Grundsyntax (Bash/Python)',
      'Schreiben einfacher Automatisierungs-Skripte für Standardaufgaben',
      'Strukturierte Skripte mit Fehlerbehandlung & Libraries, objektorientierte Basis',
      'Entwicklung von Tools/REST-APIs, Test-Frameworks, Code-Qualitäts-Standards',
      'Architektur komplexer Software-Systeme, Framework-Entwicklung, Core-Automatisierung'
    ],
    'Applikations- & Plattformentwicklung' => [
      'Kleine Code-Anpassungen (HTML/CSS/JS), Verständnis von Web-Grundlagen',
      'Entwicklung kleinerer Tools oder isolierter API-Endpunkte',
      'Umsetzung von Full-Stack-Features, Nutzung von Frameworks (React/Rails/Django)',
      'Software-Architektur, Testing-Strategien, Skalierbarkeit, Deployment-Optimierung',
      'Design von Applikations-Ökosystemen, Strategie für technologische Stacks'
    ],
    'Datenbankadministration' => [
      'Einfache SQL-Abfragen (SELECT, UPDATE), Verständnis von Tabellen-Strukturen',
      'Basis-Verwaltung, Backup/Restore, Indizes & Joins verstehen',
      'Query-Optimierung, Replikations-Einrichtung, Benutzer- & Rollenkonzepte',
      'Hochverfügbarkeits-Setups, Sharding, Design komplexer Datenmodelle',
      'Enterprise-Datenbank-Architektur, strategisches Datenmanagement, Performance-Analysen'
    ],
    'Data Engineering & Analytics' => [
      'Arbeit mit Exporten (CSV/Excel), Grundkenntnisse Statistik & Visualisierung',
      'Datenbereinigung & einfache Analysen mit Skripten (R/Python)',
      'Aufbau von ETL-Pipelines, Integration in zentrale Repositories',
      'Data-Warehouse-Management, Big-Data-Technologien, Automatisierung von Reports',
      'Design von Daten-Architekturen, Machine-Learning-Infrastruktur, Data-Governance'
    ],
    'IT-Security' => [
      'Sicherheits-Grundlagen (Passwörter, MFA), Phishing-Prävention, Updates',
      'Geführte Vulnerability-Scans, Erkennung gängiger Angriffs-Szenarien',
      'Implementierung von Schutzmaßnahmen, Risikoanalysen, IDS/IPS-Konfiguration',
      'Penetration Testing, Incident Response Management, Security-Auditierung',
      'Security-Gesamtstrategie, Compliance-Architektur (ISO 27001), Red-Teaming'
    ],
    'Monitoring & Logging' => [
      'Dashboards lesen, Verständnis von Metriken & Alert-Status',
      'Erstellung einfacher Alerts & Dashboards (Grafana/Prometheus)',
      'System-Konfiguration, Log-Aggregation (ELK/Graylog), komplexes Alerting',
      'Design von Monitoring-Strategien, SLO/SLA-Tracking, Distributed Tracing',
      'Vollständige Observability-Plattform, Predictive Analytics, Performance-Design'
    ],
    'Helpdesk & User Support' => [
      'Erfassung & Bearbeitung einfacher Anfragen, korrekte Eskalation',
      'Selbstständige Lösung von Standard-Problemen, Ticket-Dokumentation',
      'Bearbeitung komplexer Anfragen, Training von Usern, ITIL-Grundlagen',
      'Optimierung von Support-Workflows, Wissensbasis-Aufbau, Team-Koordination',
      'Strategischer Service-Desk, SLA-Design, Change-Management Steuerung'
    ],
    'Dokumentation & Wissensmanagement' => [
      'Nutzung der Dokumentation, Feedback zu Lücken geben',
      'Erstellung verständlicher How-Tos für Standard-Tasks',
      'Strukturierte Dokumentations-Konzepte, Wiki-Pflege, Konsistenz-Prüfung',
      'Aufbau von Knowledge-Management-Systemen, Versionierung, QS-Standards',
      'Wissensmanagement-Strategie, Etablierung einer Dokumentations-Kultur'
    ],
    'IT-Projektmanagement' => [
      'Mitarbeit in Projekten, Verständnis von Phasen & Meilensteinen',
      'Leitung kleinerer Teilprojekte, Zeit- & Ressourcenplanung',
      'Steuerung komplexer Projekte, Stakeholder-Management, Risiko-Controlling',
      'Programm-Management, Portfolio-Steuerung, Budget-Verantwortung',
      'Strategisches Projekt-Portfolio, Etablierung von PM-Standards'
    ],
    'Kommunikation' => [
      'Klare Formulierung einfacher Sachverhalte, aktives Zuhören',
      'Proaktive Information, konstruktives Feedback, Zielgruppen-Anpassung',
      'Souveräne Führung schwieriger Gespräche, Vermittlung komplexer Inhalte',
      'Gestaltung der Team-Kommunikationswege, Moderation von Konfliktgesprächen',
      'Strategische Kommunikation, Repräsentation der IT-Interessen auf Leitungsebene'
    ],
    'Teamarbeit & Kollaboration' => [
      'Zuverlässige Zusammenarbeit, Einhaltung von Team-Absprachen',
      'Unterstützung von Kollegen, aktive Einbringung eigener Ideen',
      'Förderung fachübergreifender Kooperation, Koordination gemeinsamer Aufgaben',
      'Aufbau cross-funktionaler Workflows, Lösung von Schnittstellen-Problemen',
      'Kultur-Design, Vernetzung von Fachbereichen, strategische Kollaboration'
    ],
    'Selbstorganisation & Zeitmanagement' => [
      'Erledigung von Aufgaben nach Priorität & Deadline',
      'Eigenständige Strukturierung des Arbeitstages, proaktives Zeit-Monitoring',
      'Management paralleler Projekte, dynamische Priorisierung unter Last',
      'Entwicklung von Systemen für komplexe Workloads, Coaching anderer',
      'Exzellente Selbststeuerung, Effizienz-Vorbild, Krisen-Resilienz'
    ],
    'Konfliktfähigkeit' => [
      'Erkennen von Spannungen, sachliche Ansprache von Problemen',
      'Aktive Suche nach Konsens, professionelle Deeskalation',
      'Moderation von Konflikten zwischen Dritten, Erarbeitung von Kompromissen',
      'Etablierung einer konstruktiven Streitkultur, Mediation bei Blockaden',
      'Systemisches Konfliktmanagement, Design reibungsarmer Organisationsformen'
    ],
    'Lernbereitschaft & Adaptabilität' => [
      'Offenheit für neue Themen, Nutzung angebotener Fortbildungen',
      'Selbstständige Einarbeitung in neue Technologien & Prozesse',
      'Aktiver Wissenstransfer im Team, Anstoß von Lern-Initiativen',
      'Strategischer Aufbau neuer Kompetenzfelder, Adaption von Trends',
      'Gestaltung der Lernkultur, Antizipation künftiger Skill-Bedarfe'
    ],
    'Führungskompetenz' => [
      'Übernahme von Eigenverantwortung, Unterstützung der Teamziele',
      'Leitung von Arbeitsgruppen oder kleinen Fach-Teams, Orientierung geben',
      'Eigenverantwortliche Teamführung, gezielte Mitarbeiter-Entwicklung',
      'Strategische Leitung, Gestaltung von Organisationseinheiten & Kultur',
      'Entwicklung von Führungskräften, Etablierung moderner Management-Frameworks'
    ],
    'Präsentation & Moderation' => [
      'Strukturierte Kurzpräsentationen vor dem Team',
      'Sichere Darstellung von Fachthemen, Beantwortung von Rückfragen',
      'Überzeugende Präsentationen für diverse Zielgruppen, Meeting-Moderation',
      'Workshops leiten, Vorträge auf Fachveranstaltungen, Storytelling',
      'Exzellente Moderation komplexer Formate, Repräsentation bei Keynotes'
    ]
  }.freeze


  def self.seed_defaults!
    DEFAULTS.each_with_index do |attrs, i|
      skill = find_or_create_by!(name: attrs[:name]) do |s|
        s.category = attrs[:category]
        s.position = i
        s.active   = true
      end

      # Seed level descriptions
      texts = LEVEL_TEXTS[attrs[:name]] || []
      texts.each_with_index do |desc, idx|
        SubskillLevelDescription.find_or_create_by!(
          subskill_skill_id: skill.id,
          level: idx + 1
        ) { |d| d.description = desc }
      end
    end
  end

  # Returns { level => description } for this skill
  def level_descriptions_map
    level_descriptions.index_by(&:level).transform_values(&:description)
  end

  # ── Tree helpers ──────────────────────────────────────────────────────── #

  def leaf?      = children.empty?
  def composite? = children.any?
  def root?      = parent_id.nil?

  # Can this skill gain children? Only if no one has rated it yet.
  def can_add_children?
    user_skills.none?
  end

  def depth
    return 0 if parent_id.nil?
    (parent&.depth || 0) + 1
  end

  # ── Flat array [{skill:, depth:}] for tree rendering (1 query) ────────── #
  def self.tree_rows(scope = nil)
    all_skills  = (scope || all).order(:position).to_a
    by_parent   = all_skills.group_by(&:parent_id)
    result      = []
    collect_rows(nil, by_parent, result, 0)
    result
  end

  def self.collect_rows(parent_id, by_parent, result, depth)
    (by_parent[parent_id] || []).each do |skill|
      result << { skill: skill, depth: depth }
      collect_rows(skill.id, by_parent, result, depth + 1)
    end
  end
  private_class_method :collect_rows

  # ── Score computation for a user (no N+1) ─────────────────────────────── #
  # Returns Hash { skill_id => Float (0..5) }
  def self.compute_scores_for_user(user_id)
    all_skills = all.to_a
    by_parent  = all_skills.group_by(&:parent_id)
    us_map     = SubskillUserSkill.where(user_id: user_id).index_by(&:subskill_skill_id)
    scores     = {}
    _score_node(nil, by_parent, us_map, scores)
    scores
  end

  def self._score_node(parent_id, by_parent, us_map, scores)
    (by_parent[parent_id] || []).each do |skill|
      kids = by_parent[skill.id] || []
      if kids.any?
        _score_node(skill.id, by_parent, us_map, scores)
        # Average of children scores (ignoring weight)
        child_scores = kids.map { |c| scores[c.id] || 0.0 }
        scores[skill.id] = child_scores.any? ? child_scores.sum / child_scores.size : 0.0
      else
        scores[skill.id] = us_map[skill.id]&.level.to_f || 0.0
      end
    end
  end
  private_class_method :_score_node

  private

  def prevent_self_parenting
    if parent_id.present? && parent_id == id
      errors.add(:parent_id, "kann nicht sich selbst als übergeordnet haben")
    end
  end

  def prevent_rated_parenting
    if parent_id_changed? && parent_id.present?
      new_parent = SubskillSkill.find_by(id: parent_id)
      if new_parent && new_parent.user_skills.any?
        errors.add(:parent_id, "kann nicht als Eltern-Skill gesetzt werden, da er bereits Bewertungen hat")
      end
    end
  end
end
