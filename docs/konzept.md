# Konzept: Skill-Management Plugin für Redmine (`redmine_subskills`)

_Stand: Mai 2026 · Verantwortlich: IT-Abteilung_

---

## Verwandte Dokumente

| Dokument | Inhalt |
|---|---|
| [Organisationskonzept](organisationskonzept.md) | IT-Organisationsmodell (Anforderungen → Systeme ← IT-Org) und Herleitung der Kompetenzfelder |
| [Rollenkonzept](rollenkonzept.md) | Vollständiger Rollen-Katalog, Hüte-Prinzip, Verteilungsmechanismus und Rollen-Kompetenz-Verknüpfung |

---

## 1. Zielsetzung

Das Plugin ermöglicht eine strukturierte, teamweite Selbsteinschätzung von **IT-Fach- und Sozialkompetenzen** direkt in Redmine. Ziel ist es, Kompetenzlücken sichtbar zu machen, Lernziele zu definieren und die Passung zwischen Personen und Rollen zu verbessern – ohne externen Tool-Overhead.

---

## 2. Skill-Katalog

### 2.1 Fachkompetenzen (IT)

| Kategorie | Skills |
|---|---|
| **Systeme** | Linux/Server-Admin, Netzwerk & Firewall, Virtualisierung & Container, Storage & Backup, IAM & Directory Services, Cloud & DevOps |
| **Entwicklung** | Python/Scripting, Applikations- & Plattformentwicklung, Datenbankadministration, Data Engineering & Analytics |
| **Security** | IT-Security |
| **Betrieb** | Monitoring & Logging, Helpdesk & User Support, Dokumentation & Wissensmanagement |
| **Allgemein** | IT-Projektmanagement |

### 2.2 Sozial- & Selbstkompetenzen

| Kompetenz | Beschreibung |
|---|---|
| **Kommunikation** | Klar, zielgruppengerecht und proaktiv kommunizieren |
| **Teamarbeit & Kollaboration** | Verlässliche Mitarbeit, cross-funktionale Zusammenarbeit |
| **Selbstorganisation & Zeitmanagement** | Eigenständige Priorisierung, Einhalten von Fristen |
| **Konfliktfähigkeit** | Souveräner Umgang mit Spannungen, Deeskalation |
| **Lernbereitschaft & Adaptabilität** | Kontinuierliches Lernen, Anpassung an Veränderungen |
| **Führungskompetenz** | Verantwortungsübernahme, Teamentwicklung |
| **Präsentation & Moderation** | Überzeugendes Präsentieren, Workshopmoderation |

### 2.3 Level-Skala (für alle Skills gleich)

| Level | Bezeichnung | Bedeutung |
|---|---|---|
| 0 | Kein Wissen | Keine Erfahrung |
| 1 | Grundkenntnisse | Grundverständnis, Unterstützung benötigt |
| 2 | Anwender | Selbständig in Standardsituationen |
| 3 | Fortgeschritten | Selbständig auch in komplexen Situationen |
| 4 | Experte | Kann andere anleiten, löst Sonderfälle |
| 5 | Spezialist | Tiefste Expertise, gestaltet Standards |

Jede Stufe ist **pro Skill** mit einem konkreten Verhaltensbeschreibungs-Text hinterlegt.

---

## 3. Funktionen im Plugin

### 3.1 Team-Matrix (`/subskills`)
- Tabelle: Zeilen = Skills (nach Kategorie), Spalten = alle aktiven User
- Zellen zeigen Level-Badge (0–5) farbkodiert
- 🎯-Markierung wenn Skill als Lernziel gesetzt (Priorität 1–3)
- Klick auf Avatar → Profil des Users

### 3.2 Persönliches Skill-Profil (`/subskills/user/:id`)
- **Runde Auswahlboxen (0–5)** pro Skill statt Slider
- Alle 5 Level-Beschreibungen pro Skill sichtbar, aktive hervorgehoben
- **Lernziel-Prioritäten**: Pro User können max. 3 Skills priorisiert werden:
  - 🔴 Priorität 1 (höchste)
  - 🟠 Priorität 2
  - 🟡 Priorität 3
  - Jede Priorität ist nur einmal vergebar (exklusiv)
- **Radar-Chart** (Chart.js) zeigt das Kompetenzprofil visuell
- Speichern per Submit

### 3.3 Admin-Bereich (`/subskills/admin`)
- CRUD für Skill-Katalog
- Kategorie und Reihenfolge verwaltbar
- Skills können deaktiviert werden (bleiben in History erhalten)

---

## 4. Rollen-Kompetenz-Matrix (geplant)

> **Idee**: Für jede Rolle im Team wird definiert, welche Fach- und Sozialkompetenzen **wie wichtig** sind.

### 4.1 Gewichtungsskala

| Stufe | Bezeichnung |
|---|---|
| 0 | Nicht relevant |
| 1 | Hilfreich |
| 2 | Wichtig |
| 3 | Erforderlich |

### 4.2 Beispiel: Rollen-Kompetenz-Anforderungen

| Rolle | Kommunikation | Führung | Linux/Admin | IT-Security | Selbstorganisation |
|---|---|---|---|---|---|
| System-Owner | 2 | 2 | 3 | 2 | 2 |
| IT-Security Officer | 3 | 2 | 1 | 3 | 2 |
| 1st-Level Dispatcher | 3 | 1 | 1 | 1 | 3 |
| IT-Projektmanager | 3 | 3 | 1 | 1 | 3 |
| Research Software Eng. | 2 | 1 | 2 | 1 | 2 |
| Knowledge Manager | 3 | 2 | 1 | 1 | 3 |
| Incident Commander | 3 | 3 | 2 | 2 | 2 |

### 4.3 Darstellungsidee: Fit-Score

- Für jede Person × Rolle: Σ(Skill-Level × Gewichtung) / Σ(Max-Gewichtung × 5)
- Ergibt einen **Fit-Prozentsatz** (0–100%)
- Darstellung als Balken oder Farb-Heatmap in der Team-Matrix
- Zeigt auf einen Blick: Wer passt am besten auf welche Rolle?

### 4.4 Datenbankstruktur (geplant)

```sql
CREATE TABLE subskill_role_requirements (
  id         SERIAL PRIMARY KEY,
  role_name  TEXT NOT NULL,
  skill_id   INTEGER REFERENCES subskill_skills(id),
  importance INTEGER DEFAULT 0  -- 0=n/a, 1=hilfreich, 2=wichtig, 3=erforderlich
);
```

---

## 5. Datenbankstruktur (aktuell)

```
subskill_skills
  id, name, category, position, active, description

subskill_level_descriptions
  id, subskill_skill_id, level (1-5), description

subskill_user_skills
  id, user_id, subskill_skill_id, level (0-5), learn_priority (0-3)
```

---

## 6. Integration in Redmine

- **Top-Navigation**: Menüpunkt „Skills" im Haupt-Menü
- **Admin-Menü**: „Skills verwalten" im Redmine-Adminbereich
- **Profil-Link**: Direkt über die User-Avatar-Buttons erreichbar
- **Design**: Native Redmine CSS-Klassen, kein externes Framework

---

## 7. Offene Punkte / Roadmap

| Priorität | Feature |
|---|---|
| Hoch | Rollen-Kompetenz-Matrix implementieren (DB + UI) |
| Hoch | Fit-Score-Berechnung und Darstellung |
| Mittel | Admin: Level-Beschreibungen editierbar machen |
| Mittel | Export (CSV/PDF) der Team-Matrix |
| Niedrig | Profil-Tab direkt im Redmine-Benutzerprofil |
| Niedrig | Historisierung von Skill-Entwicklung über Zeit |
