# Redmine Sub-Skills Plugin

> Empower your team with intelligent skill tracking and role matching directly in Redmine.

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](LICENSE)
[![Redmine Version](https://img.shields.io/badge/Redmine-4.0%2B-red.svg)](https://www.redmine.org/)

## ✦ What is Sub-Skills?

The Sub-Skills plugin transforms Redmine into a comprehensive competence management tool. It enables organizations to track employee skills, define required roles, and find the perfect match for project requirements.

**Core Features:**
- ❖ **Skill Catalog**: Centrally manage roles, competencies, and skill requirements
- ⚲ **Personal Profiles**: Users can maintain and update their own skill profiles
- ⌖ **Role Matching**: Automatically calculate how well a user fits a specific role
- ⊞ **Team Matrices**: Visual skill matrix and role-fit overview for entire teams
- ⚒ **Project Integration**: Define skill requirements for projects and find the "Best Match"
- ⚙ **Admin Controls**: Dedicated administration panel for managing the underlying skill taxonomy

## ⎚ Screenshots

*(Screenshot placeholders - Add your images here)*

## ⬢ Installation

### Requirements
- **Redmine**: Version 4.0.0 or higher
- **Ruby**: Compatible with your Redmine installation
- **Permissions**: Admin access for initial setup

### Quick Setup

1. **Download & Extract**
   ```bash
   cd /path/to/redmine/plugins
   git clone https://github.com/modoq/redmine_subskills.git
   ```

2. **Run Migrations**
   ```bash
   bundle exec rake redmine:plugins:migrate NAME=redmine_subskills RAILS_ENV=production
   ```

3. **Restart Redmine**
   ```bash
   # For development
   bundle exec rails server

   # For production (passenger/nginx)
   sudo systemctl restart redmine
   ```

4. **Configure Plugin**
   - Navigate to **Administration → Skills** to set up your skill catalog
   - Enable the "Subskills" module in your projects

## ⎈ Usage Guide

### 1. The Skill Catalog
The foundation of the plugin. Define the available skills, group them into logical categories, and assemble them into target profiles (Roles).

### 2. Personal Skill Management
Users access "My Skills" to self-assess their competencies against the available catalog. The "Rollen-Passung" (Role Match) view shows them their readiness for specific career paths or project roles.

### 3. Team & Project Management
- **Skill Matrix Team**: Managers get a birds-eye view of all available skills in their team.
- **Project Requirements**: Inside a project, use the "Skills" tab to define what competencies are needed.
- **Best Match**: The system automatically suggests the best fitting team members for the project based on their skill profiles.

## ⇋ Contributing

We welcome contributions! Here's how to get started:

1. **Fork** the repository
2. **Create** a feature branch (`git checkout -b feature/amazing-feature`)
3. **Commit** your changes (`git commit -m 'Add amazing feature'`)
4. **Push** to the branch (`git push origin feature/amazing-feature`)
5. **Open** a Pull Request

## ⚖ License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## ✉ Contact

- ⚠ **Issues**: [GitHub Issues](https://github.com/modoq/redmine_subskills/issues)
- 🗨 **Discussions**: [GitHub Discussions](https://github.com/modoq/redmine_subskills/discussions)
- @ **Contact**: [Project Author](https://github.com/modoq)

---

*"Building the perfect team starts with knowing your skills."*
