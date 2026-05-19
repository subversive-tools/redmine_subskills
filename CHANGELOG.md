# Changelog

All notable changes to this project will be documented in this file.
The format follows [Keep a Changelog](https://keepachangelog.com/en/1.0.0/).

## [1.0.0] - 2026-05-16

### Changed
- Declared stable release — all core features considered production-ready.
- Fixed migration version compatibility (changed `7.2` to `5.2`) for broader Rails support.

## [0.3.0] - 2026-05-15

### Added
- **Peer Endorsements:** Users can now endorse skills of their colleagues directly from the user profile or team matrix.
- **I18n Translation:** Complete translation support for German and English across all views and menus.
- **Optimistic UI:** Fast visual feedback (green highlights, instant counters) when endorsing a skill.

### Changed
- **Matrix Sorting:** Streamlined matrix layouts and pruned legacy/duplicate skills for cleaner admin and team views.
- **UI Refinements:** Improved vertical alignments and spacing for learning goals and skill lists.

## [0.2.0] - 2026-05-14

### Added
- **Skill Hierarchies:** Support for parent-child relationships, tree views, and drag-and-drop reparenting.
- **Admin UI:** Comprehensive layout similar to Redmine users administration, including skill categories.
- **Project Skills:** "Best-Match" suggestions, tooltips, and an intuitive "Add-Member" modal.
- **Documentation:** Added a polished `README.md` and detailed internal concept documents (`Organisationskonzept`, `Rollenkonzept`).
- **Release Workflow:** Standardized release workflow for AI assistants.

### Changed
- **Styling:** Refactored various views to use CSS utility classes instead of inline styles.

### Fixed
- Corrected author attribution in configuration files.

## [0.1.0] - Initial
- Initial plugin structure and core logic.
