namespace :subskills do
  desc 'Migrate role requirements to project-based skill requirements'
  task migrate_to_projects: :environment do
    # Mapping: Redmine project identifier => { category, role_name }
    PROJECT_ROLES = [
      { id: 196, identifier: 'netzwerk-firewall-owner',      role: 'Netzwerk & Firewall Owner',       category: 'A. System-Owner' },
      { id: 197, identifier: 'virtualization-compute-owner', role: 'Virtualization & Compute Owner',   category: 'A. System-Owner' },
      { id: 198, identifier: 'storage-backup-owner',         role: 'Storage & Backup Owner',           category: 'A. System-Owner' },
      { id: 199, identifier: 'iam-directory-owner',          role: 'IAM & Directory Owner',            category: 'A. System-Owner' },
      { id: 200, identifier: 'client-management-owner',      role: 'Client-Management Owner',          category: 'A. System-Owner' },
      { id: 201, identifier: 'app-owner-1',                  role: 'Applikations-Owner',               category: 'A. System-Owner' },
      { id: 202, identifier: 'app-owner-2',                  role: 'Applikations-Owner',               category: 'A. System-Owner' },
      { id: 203, identifier: 'app-owner-3',                  role: 'Applikations-Owner',               category: 'A. System-Owner' },
      { id: 204, identifier: 'it-security-officer',          role: 'IT-Security Officer',              category: 'B. Governance & IT-Management' },
      { id: 205, identifier: 'it-compliance-privacy',        role: 'IT-Compliance & Privacy Manager',  category: 'B. Governance & IT-Management' },
      { id: 206, identifier: 'knowledge-manager',            role: 'Knowledge Manager',                category: 'B. Governance & IT-Management' },
      { id: 207, identifier: 'it-asset-procurement',         role: 'IT-Asset & Procurement Manager',   category: 'B. Governance & IT-Management' },
      { id: 208, identifier: 'it-portfolio-manager',         role: 'IT-Portfolio Manager',             category: 'B. Governance & IT-Management' },
      { id: 209, identifier: '1st-level-dispatcher',         role: '1st-Level Dispatcher',             category: 'C. Operative Rollen' },
      { id: 210, identifier: 'incident-commander',           role: 'Incident Commander',               category: 'C. Operative Rollen' },
      { id: 211, identifier: 'release-manager',              role: 'Release Manager',                  category: 'C. Operative Rollen' },
      { id: 212, identifier: 'it-automation-architect',      role: 'IT-Automation Architect',          category: 'C. Operative Rollen' },
      { id: 213, identifier: 'data-engineer',                role: 'Data Engineer',                    category: 'D. Research IT' },
      { id: 214, identifier: 'research-software-engineer',   role: 'Research Software Engineer',       category: 'D. Research IT' },
      { id: 215, identifier: 'lab-it-specialist',            role: 'Lab IT Specialist',                category: 'D. Research IT' },
      { id: 216, identifier: 'service-owner',                role: 'Service Owner',                    category: 'E. IT-Service-Management' },
    ].freeze

    PROJECT_ROLES.each do |entry|
      project = Project.find_by(id: entry[:id]) || Project.find_by(identifier: entry[:identifier])
      unless project
        puts "  SKIP – project #{entry[:identifier]} not found"
        next
      end

      # Register as role-project
      spr = SubskillProjectRole.find_or_create_by!(project_id: project.id) do |r|
        r.category = entry[:category]
      end
      spr.update!(category: entry[:category])

      # Migrate requirements from SubskillRole
      old_role = SubskillRole.find_by(name: entry[:role])
      unless old_role
        puts "  SKIP requirements – no SubskillRole '#{entry[:role]}'"
        next
      end

      old_role.requirements.each do |req|
        SubskillProjectRequirement.find_or_create_by!(
          project_id:       project.id,
          subskill_skill_id: req.subskill_skill_id
        ) { |r| r.importance = req.importance }
      end

      puts "  OK  #{project.name} (#{old_role.requirements.count} requirements)"
    end

    puts "\nDone. #{SubskillProjectRole.count} role-projects, #{SubskillProjectRequirement.count} requirements."
  end
end
