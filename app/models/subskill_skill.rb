class SubskillSkill < ActiveRecord::Base
  self.table_name = 'subskill_skills'

  CATEGORIES = [
    'Systeme',
    'Entwicklung',
    'Security',
    'Betrieb',
    'Allgemein',
    'Sozial- & Selbstkompetenz'
  ].freeze

  has_many :user_skills,      class_name: 'SubskillUserSkill',       foreign_key: 'subskill_skill_id', dependent: :destroy
  has_many :level_descriptions, class_name: 'SubskillLevelDescription', foreign_key: 'subskill_skill_id', dependent: :destroy

  accepts_nested_attributes_for :level_descriptions, allow_destroy: false

  validates :name, presence: true, uniqueness: true
  validates :category, presence: true

  scope :active,  -> { where(active: true) }
  scope :ordered, -> { order(:category, :position, :name) }

  DEFAULTS = [
    { name: 'Linux / Server-Administration',          category: 'Systeme' },
    { name: 'Netzwerk & Firewall',                    category: 'Systeme' },
    { name: 'Virtualisierung & Containerisierung',    category: 'Systeme' },
    { name: 'Storage & Backup Management',            category: 'Systeme' },
    { name: 'IAM & Directory Services',               category: 'Systeme' },
    { name: 'Cloud & DevOps',                         category: 'Systeme' },
    { name: 'Python / Scripting',                     category: 'Entwicklung' },
    { name: 'Applikations- & Plattformentwicklung',   category: 'Entwicklung' },
    { name: 'Datenbankadministration',                category: 'Entwicklung' },
    { name: 'Data Engineering & Analytics',           category: 'Entwicklung' },
    { name: 'IT-Security',                            category: 'Security' },
    { name: 'Monitoring & Logging',                   category: 'Betrieb' },
    { name: 'Helpdesk & User Support',                category: 'Betrieb' },
    { name: 'Dokumentation & Wissensmanagement',      category: 'Betrieb' },
    { name: 'IT-Projektmanagement',                   category: 'Allgemein' },
    { name: 'Kommunikation',                           category: 'Sozial- & Selbstkompetenz' },
    { name: 'Teamarbeit & Kollaboration',               category: 'Sozial- & Selbstkompetenz' },
    { name: 'Selbstorganisation & Zeitmanagement',      category: 'Sozial- & Selbstkompetenz' },
    { name: 'Konfliktfähigkeit',                        category: 'Sozial- & Selbstkompetenz' },
    { name: 'Lernbereitschaft & Adaptabilität',         category: 'Sozial- & Selbstkompetenz' },
    { name: 'Führungskompetenz',                        category: 'Sozial- & Selbstkompetenz' },
    { name: 'Präsentation & Moderation',                category: 'Sozial- & Selbstkompetenz' },
  ].freeze

  LEVEL_TEXTS = {
    'Linux / Server-Administration' => [
      'Führt einfache Befehle aus (ls, cd, ps), navigiert das Dateisystem, liest Logs',
      'Verwaltet Benutzer/Dienste via systemd, nutzt Paketmanager, bearbeitet Konfigdateien',
      'Konfiguriert und wartet Server selbstständig: Backup, Monitoring, Netzwerk-Grundlagen',
      'Automatisiert Aufgaben per Skript, Security-Hardening, Performance-Tuning, Kernel-Parameter',
      'Designt Server-Landschaften, löst komplexe Systemprobleme, tiefes Kernel- und Performance-Know-how',
    ],
    'Netzwerk & Firewall' => [
      'Kennt IP-Adressen/Subnetting, nutzt ping/traceroute, versteht DNS-Grundlagen',
      'Konfiguriert VLANs und einfache Firewall-Regeln, versteht Routing-Grundlagen',
      'Implementiert Netzwerkstrukturen, verwaltet Switch/Router-Konfigurationen selbstständig',
      'Designt komplexe Topologien, BGP/OSPF-Kenntnisse, Firewall-Policies, VPN-Infrastrukturen',
      'Vollständiges Netzwerk-Design, Security-Audits, Carrier-Grade-Kenntnisse, Deep Packet Inspection',
    ],
    'Virtualisierung & Containerisierung' => [
      'Kennt Konzepte von VMs und Containern (Docker), kann fertige Container starten/stoppen',
      'Erstellt eigene Docker-Images, schreibt einfache docker-compose Files, verwaltet Basis-VMs',
      'Administriert Virtualisierungs-Cluster (Proxmox/vSphere) und baut Multi-Container-Setups',
      'Kubernetes-Grundlagen (K8s), Live-Migrationen, Ceph-Storage, CI/CD-Integration von Containern',
      'Designt komplexe K8s/Virtualisierungs-Infrastrukturen, Cluster-Architektur, Kapazitätsplanung',
    ],
    'Storage & Backup Management' => [
      'Kann Laufwerke einbinden, kennt RAID-Konzepte, bedient bestehende Backups',
      'Konfiguriert NFS/SMB-Shares, richtet automatisierte Backup-Jobs ein (Veeam, PBS)',
      'Betreibt Storage-Cluster (z. B. Ceph), Kapazitätsplanung, Disaster-Recovery-Tests',
      'Storage-Tiering, Performance-Tuning für IOPS-kritische Systeme, Replikation über Standorte',
      'Enterprise-Storage-Architektur, vollständiges Lifecycle-Management und BCM',
    ],
    'IAM & Directory Services' => [
      'Legt Benutzer an, verwaltet einfache Gruppenrechte, versteht Passwort-Policies',
      'Administriert Active Directory / LDAP, konfiguriert Gruppenrichtlinien (GPOs)',
      'Integriert Systeme in IAM-Lösungen, implementiert Single-Sign-On (OAuth/SAML)',
      'Baut Identity-Federations (z. B. SWITCHaai) auf, Role-Based Access Control',
      'Designt vollständige Identity-Landschaften, Zero-Trust-Architektur',
    ],
    'Cloud & DevOps' => [
      'Versteht Cloud-Konzepte (IaaS/PaaS/SaaS), kann bestehende CI/CD-Pipelines nutzen',
      'Erstellt Docker-Images, einfache CI/CD-Pipelines, versteht Git-Workflows',
      'Verwaltet Cloud-Ressourcen, konfiguriert CI/CD selbstständig, Container-Orchestrierung',
      'Infrastructure as Code (Terraform/Ansible), Kubernetes-Grundlagen, Multi-Cloud-Strategien',
      'Entwirft DevOps-Plattformen, GitOps, komplexe K8s-Deployments, Platform Engineering',
    ],
    'Python / Scripting' => [
      'Liest Skripte, nimmt kleine Anpassungen vor, versteht Grundsyntax (Bash oder Python)',
      'Schreibt einfache Automatisierungs-Skripte für wiederkehrende Aufgaben',
      'Robuste Skripte mit Fehlerbehandlung, nutzt Bibliotheken, versteht objektorientierte Konzepte',
      'Komplexe Automatisierungslösungen, REST-APIs, Testabdeckung, Code-Reviews',
      'Professionelle Softwareentwicklung, Architekturentscheidungen, Open-Source-Beiträge',
    ],
    'Applikations- & Plattformentwicklung' => [
      'Macht kleine Code-Anpassungen im Frontend (HTML/JS) oder Backend, versteht Basis-Webkonzepte',
      'Entwickelt selbstständig kleinere Applikationen, Tools oder einfache APIs (Web oder native)',
      'Baut produktive Full-Stack-Applikationen, Framework-Kenntnisse (z.B. React/Vue, Node/Django)',
      'Führt Architektur-Entscheidungen für Apps, Microservices, CI/CD-Testing, Skalierbarkeit',
      'Designt komplexe, institutionsweite Software-Architekturen und Plattform-Ökosysteme',
    ],
    'Datenbankadministration' => [
      'Führt einfache SQL-Queries aus (SELECT, INSERT, UPDATE, DELETE)',
      'Verwaltet Datenbanken, kennt Joins und Indizes, führt Backup/Restore durch',
      'Optimiert Queries, Replikation, Benutzerverwaltung, arbeitet mit mehreren DB-Systemen',
      'Performance-Tuning, Hochverfügbarkeit, Sharding, Design komplexer Datenbankstrukturen',
      'Enterprise-Datenbankdesign, Disaster Recovery, Cross-Platform-Migration, SLA-Garantien',
    ],
    'Data Engineering & Analytics' => [
      'Arbeitet mit exportierten Daten (Excel/CSV), grundlegende Statistik-Kenntnisse',
      'Schreibt einfache Skripte (R, Python) zur Datenbereinigung und Visualisierung',
      'Baut ETL-Pipelines auf, integriert Forschungsdaten in zentrale Repositories',
      'Verwaltet komplexe Data-Warehouses/Data-Lakes, Big-Data-Technologien',
      'Design wissenschaftlicher Datenarchitekturen, Machine-Learning-Infrastruktur',
    ],
    'IT-Security' => [
      'Kennt Sicherheitsgrundlagen: starke Passwörter, Updates, Phishing-Erkennung',
      'Führt einfache Vulnerability-Scans durch, kennt gängige Angriffsvektoren',
      'Implementiert Sicherheitskonzepte, führt Risikoanalysen durch, konfiguriert IDS/IPS',
      'Penetration Testing, Security-Audits, Incident Response, SIEM-Betrieb',
      'Security-Architektur, Red-Team-Fähigkeiten, Compliance (ISO 27001, BSI-Grundschutz)',
    ],
    'Monitoring & Logging' => [
      'Liest bestehende Dashboards, versteht grundlegende Metriken und Alert-Meldungen',
      'Erstellt einfache Alerts, kennt Prometheus/Grafana oder Zabbix-Grundlagen',
      'Konfiguriert Monitoring-Systeme, erstellt komplexe Dashboards, Log-Aggregation',
      'Entwirft Monitoring-Strategien, SLO/SLA-Definition, Distributed Tracing',
      'Vollständige Observability-Plattform, Performance-Engineering, Anomalie-Detektion',
    ],
    'Helpdesk & User Support' => [
      'Beantwortet einfache Anfragen, eskaliert bei komplexeren Problemen zuverlässig',
      'Löst häufige Probleme selbstständig, dokumentiert Lösungen im Ticketsystem',
      'Bearbeitet komplexe User-Probleme, ITIL-Kenntnisse, führt Schulungen durch',
      'Optimiert Support-Prozesse, baut Wissensdatenbanken auf, koordiniert das Team',
      'Strategischer IT-Support, SLA-Design, Change-Management, Service-Desk-Strategie',
    ],
    'Dokumentation & Wissensmanagement' => [
      'Liest und nutzt vorhandene Dokumentation effektiv, gibt Feedback zu Lücken',
      'Schreibt verständliche How-Tos und Anleitungen für häufige Aufgaben',
      'Erstellt strukturierte Dokumentationskonzepte, pflegt Wikis aktiv und konsistent',
      'Baut Wissensmanagement-Systeme auf, Versionskontrolle für Dokumentation, Qualitätssicherung',
      'Wissensmanagement-Strategie, Standardisierung, Knowledge-Community, institutionelles Gedächtnis',
    ],
    'IT-Projektmanagement' => [
      'Arbeitet in Projekten mit, versteht grundlegende Projektmanagement-Methoden',
      'Leitet kleine Projekte selbstständig, erstellt Zeit- und Ressourcenpläne',
      'Verantwortet mittlere bis grosse IT-Projekte, Stakeholder-Management, Risikoanalyse',
      'Program-Management, steuert komplexe Projekt-Portfolios, Budgetverantwortung',
      'Strategisches Portfolio-Management, prägt die Projektkultur der gesamten Organisation',
    ],
    'Kommunikation' => [
      'Formuliert einfache Sachverhalte klar und verständlich, hört aktiv zu',
      'Kommuniziert proaktiv, gibt konstruktives Feedback, passt Stil an Zielgruppe an',
      'Führt schwierige Gespräche souverän, vermittelt komplexe Themen zielgruppengerecht',
      'Gestaltet Kommunikationsstrukturen im Team, fördert offene Gesprächskultur',
      'Exzellente interne & externe Kommunikation, prägt die Kommunikationskultur der Organisation',
    ],
    'Teamarbeit & Kollaboration' => [
      'Arbeitet zuverlässig im Team mit, hält Absprachen ein',
      'Bringt eigene Ideen konstruktiv ein, unterstützt Kolleg:innen aktiv',
      'Fördert Zusammenarbeit über Teamgrenzen hinweg, koordiniert gemeinsame Aufgaben',
      'Baut cross-funktionale Zusammenarbeit auf, löst Reibungen zwischen Teams',
      'Schafft eine starke Kollaborationskultur, vernetzt Fachbereiche strategisch',
    ],
    'Selbstorganisation & Zeitmanagement' => [
      'Erledigt Aufgaben zuverlässig mit klaren Vorgaben und Deadlines',
      'Priorisiert selbstständig, strukturiert Arbeitstag und hält Fristen ein',
      'Verwaltet parallele Aufgaben und Projekte effizient, passt Prioritäten dynamisch an',
      'Entwickelt persönliche Systeme für komplexe Arbeitslast, coacht andere beim Zeitmanagement',
      'Exzellente Selbststeuerung auch unter hohem Druck, Vorbild für effizientes Arbeiten',
    ],
    'Konfliktfähigkeit' => [
      'Erkennt Spannungen und spricht Probleme an, ohne Eskalation zu verursachen',
      'Führt sachliche Konfliktgespräche, sucht aktiv nach gemeinsamen Lösungen',
      'Moderiert Konflikte zwischen Dritten, findet tragfähige Kompromisse',
      'Deeskaliert auch festgefahrene Situationen, etabliert konstruktive Streitkultur',
      'Systemisches Konfliktmanagement, entwickelt Organisationsstrukturen die Konflikte reduzieren',
    ],
    'Lernbereitschaft & Adaptabilität' => [
      'Offen für neue Aufgaben, ergreift Lernchancen wenn sie angeboten werden',
      'Eignet sich neue Themen selbstständig an, passt sich veränderten Anforderungen an',
      'Lernt kontinuierlich proaktiv, teilt Wissen im Team und regt andere zum Lernen an',
      'Treibt organisationales Lernen voran, baut neue Kompetenzen strategisch auf',
      'Gestaltet Lernkultur der Organisation, antizipiert Kompetenzbedarfe frühzeitig',
    ],
    'Führungskompetenz' => [
      'Übernimmt Verantwortung für eigene Aufgaben, unterstützt das Team',
      'Leitet kleine Teams oder Arbeitspakete, gibt klare Orientierung',
      'Führt Teams eigenverantwortlich, entwickelt Mitarbeitende gezielt weiter',
      'Strategische Führung, gestaltet Organisationseinheiten und Führungskultur',
      'Exzellente Führungspersönlichkeit, entwickelt Führungskräfte und prägt die Unternehmenskultur',
    ],
    'Präsentation & Moderation' => [
      'Hält einfache Kurzpräsentationen vor bekanntem Publikum',
      'Präsentiert Themen strukturiert, beantwortet Fragen sicher',
      'Gestaltet überzeugende Präsentationen für verschiedene Zielgruppen, moderiert Meetings',
      'Hält Vorträge auf Fachveranstaltungen, moderiert Workshops und grössere Gruppen',
      'Keynote-Qualität, exzellente Moderation komplexer Formate und grosser Veranstaltungen',
    ],
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
end
