# Redmine Subskills Plugin

![Version](https://img.shields.io/badge/version-0.2.0-blue.svg)
![Redmine](https://img.shields.io/badge/Redmine-5.0%20%7C%206.0-red.svg?logo=redmine)
![License](https://img.shields.io/badge/license-MIT-green.svg)

A Redmine plugin for skill tracking and role matching. Teams maintain their own competence profiles, managers see who fits a project best — all within Redmine, no separate HR system required.

> Built for organisations that want competence management without a proprietary platform.

## Screenshots

*(Screenshots coming soon)*

## Features

- **Skill catalog**: centrally manage roles, competencies, and skill requirements
- **Personal profiles**: users maintain and self-assess their own skill levels
- **Role matching**: automatically calculate how well a user fits a defined role
- **Team matrix**: visual skill matrix and role-fit overview for entire teams
- **Project integration**: define skill requirements per project and find the best match
- **Admin controls**: dedicated administration panel for managing the skill taxonomy

## Requirements

- Redmine 5.0 or higher
- Admin access for initial setup

## Installation

> [!IMPORTANT]
> The plugin directory **MUST** be named `redmine_subskills` for assets to load correctly.

1. **Clone** into your plugins directory:
   ```bash
   cd /path/to/redmine/plugins
   git clone https://github.com/subversive-tools/redmine_subskills.git redmine_subskills
   ```

2. **Run migrations**:
   ```bash
   bundle exec rake redmine:plugins:migrate RAILS_ENV=production
   ```

3. **Restart Redmine**.

4. **Set up the skill catalog** under **Administration > Skills**.

## Configuration

Navigate to **Administration > Plugins > Subskills > Configure**.

| Option | Description | Default |
|:---|:---|:---|
| **Levels count** | Number of proficiency levels (e.g. 0–5) | `5` |
| **Level labels** | Custom labels for each level | Keine / Basic / … / Experte |
| **Fit thresholds** | % thresholds for green/yellow/red role-fit indicator | 70 / 40 |
| **Enable endorsements** | Allow peers to endorse skill entries | Enabled |
| **Default view mode** | Initial view for skill matrix (`split`, `full`) | `split` |
| **Allow self-assessment** | Users can rate their own skills | Enabled |

### Permissions

Go to **Administration > Roles and permissions** and configure:

| Permission | Description |
|:---|:---|
| *View subskills* | See skill profiles and matrices in a project |
| *Manage subskills* | Edit skill requirements and team assignments |

## Usage

### Skill catalog

Under **Administration > Skills**, define the available skills, group them into categories, and assemble them into role profiles.

### Personal skills

Users access **My Skills** from the top menu to self-assess their competencies. The **Role Match** view shows readiness for specific roles or career paths.

### Team & project view

Enable the **Skills** module in a project to access:

- **Skill Matrix**: overview of all skills available in the team
- **Role Match**: fit score per team member for defined role profiles
- **Best Match**: suggested team members for the project based on skill fit

## Contributing

Contributions are welcome — please fork the repository and open a Pull Request.

1. Fork it
2. Create your feature branch (`git checkout -b feature/my-feature`)
3. Commit your changes
4. Push to the branch
5. Open a Pull Request

## License

[MIT License](LICENSE) — Copyright (c) 2026 Stefan Mischke
