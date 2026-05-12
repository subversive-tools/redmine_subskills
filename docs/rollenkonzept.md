# IT-Rollenkonzept: Modulare Verantwortlichkeiten

_Stand: Mai 2026 · Verantwortlich: IT-Abteilung_

---

Dieses Konzept beschreibt einen modernen, flexiblen Ansatz zur Verteilung von Aufgaben innerhalb des IT-Teams. Das Ziel ist es, weg von starren Jobtiteln (z. B. „Der Netzwerk-Admin") hin zu einem agilen **„Hüte-Prinzip" (Role-based Organization)** zu wechseln.

Jedes Teammitglied kann – je nach individuellen Kompetenzen (erfasst über das `redmine_subskills`-Plugin) und persönlichen Interessen – mehrere Hüte (Rollen) aufsetzen.

---

## 1. Das „Hüte-Prinzip" (Role-Based Organization)

* **Granularität:** Rollen sind spezifisch und klar umrissen.
* **Trennung von Person und Rolle:** Eine Person kann mehrere Rollen innehaben. Eine Rolle kann (im Falle einer Stellvertretung) von mehreren Personen geteilt werden.
* **Rollen ≠ Hierarchie:** Rollen definieren Verantwortungsbereiche, keinen Status oder Vorgesetztenfunktion.
* **Skill-Matching:** Die Verteilung der Rollen erfolgt evidenzbasiert über die in Redmine erhobene Kompetenzmatrix und die deklarierten Lerninteressen der Mitarbeitenden.
* **Zeitbudget pro Rolle:** Jede Rolle wird mit einem Richtwert für den erwarteten Zeitanteil versehen (z. B. 10 %, 20 %, 40 %), um Überlastung messbar zu machen.
* **Primary / Secondary:** Jede kritische Rolle hat einen **Primary** (Lead/Hauptverantwortlich) und mindestens einen **Secondary** (Stellvertretung/Co-Pilot). Das verhindert Kopfmonopole.
* **Prioritätsklarheit:** Da eine Person mehrere Hüte trägt, gilt im Zweifel zwingend folgende Reihenfolge: 1. Major Incidents & Betriebssicherheit > 2. Regulärer operativer Betrieb > 3. System-Owner-Verantwortung > 4. Optimierungs- & Innovationsrollen.

---

## 2. Der Rollen-Katalog

Die Rollen unterteilen sich in fünf logische Hauptkategorien. Diese Liste dient als Baukasten, aus dem sich die Teammitglieder bedienen können.

### A. System-Owner (Domänen-Experten)
*Diese Rollen tragen die End-to-End-Verantwortung für eine bestimmte technische Domäne (Architektur, Betrieb, Lifecycle).*

* **Netzwerk & Firewall Owner:** Trägt die End-to-End-Verantwortung für die Netzwerkinfrastruktur. Plant, konfiguriert und überwacht Switches, Routing-Protokolle, VPN-Gateways und Firewall-Rulesets. Ist die letzte Eskalationsstufe bei Netzwerkproblemen und sorgt proaktiv für ausreichende Bandbreiten und physische Netzwerksicherheit in den Instituten.
* **Virtualization & Compute Owner:** Verwaltet und skaliert die Virtualisierungsumgebungen (Proxmox, VMware). Kümmert sich um das Ressourcen-Management (CPU, RAM, Disks), plant Kapazitätserweiterungen und ist verantwortlich für das Patch-Management der Hypervisoren sowie das reibungslose Failover bei Hardware-Defekten.
* **Storage & Backup Owner:** Verwaltet zentrale Storage-Systeme (SAN/NAS), überwacht Speicherauslastung und Quotas und verantwortet die Backup-Strategie. Stellt sicher, dass Backups geschrieben und im Notfall (z. B. Ransomware) zuverlässig wiederhergestellt werden können.
* **Endpoint & Client Management Owner:** Verantwortlich für das Management der Arbeitsgeräte (Laptops/Desktops) der Mitarbeitenden und Forschenden. Definiert Standard-Hardware, pflegt das MDM und automatisiert die Software-Verteilung.
* **Identity & Access Owner (IAM):** Konzeptioniert und pflegt das Active Directory, kümmert sich um Single-Sign-On-Anbindungen (SSO) und verantwortet den Lebenszyklus von Benutzerkonten. Sorgt für saubere Gruppen- und Rollenkonzepte.
* **Cloud & DevOps Architect:** Führt den Einsatz von Infrastructure-as-Code (Terraform, Ansible) an, entwirft CI/CD-Pipelines und evaluiert externe Cloud-Dienste in das bestehende Portfolio.
* **Applikations-Owner (pro App):** Spezialisierte Rollen für einzelne Kern-Applikationen. Verantwortlich für den technischen Betrieb, die Verfügbarkeit, Updates, Schnittstellen-Management und den gesamten Lifecycle der Applikation.

### B. Prozess- & Governance-Rollen (Die Struktur-Geber)
*Diese Rollen sind prozessualer Natur und sorgen dafür, dass die IT als Organisation reibungslos, sicher und konform läuft.*

* **IT-Security Officer:** Definiert und überwacht das Sicherheitsniveau der gesamten IT. Führt Vulnerability-Scans durch, evaluiert Security-Richtlinien und übernimmt bei Sicherheitsvorfällen den Lead (Incident Response). Diese Rolle hat ein Veto-Recht bei sicherheitskritischen Architektur-Entscheidungen.
* **IT-Compliance & Privacy Manager:** Agiert als Brücke zwischen der technischen IT und den rechtlichen/universitären Vorgaben. Berät bei Anonymisierungskonzepten, stellt DSGVO-Konformität sicher und überwacht die Einhaltung von Software-Lizenzen und IT-Richtlinien.
* **Knowledge Manager:** Baut und pflegt die Struktur der internen Wikis, entwickelt Onboarding-Material und fordert aktiv Dokumentationen von den System-Ownern ein.
* **IT-Asset & Procurement Manager:** Führt das Hardware- und Software-Inventar (CMDB, Asset-Tracking), verwaltet Leihgeräte-Pools und steuert IT-Beschaffungen. Überwacht Hardware-Lifecycles und optimiert Lizenz-Pools.
* **IT-Portfolio Manager:** Behält den methodischen Überblick über alle anstehenden und laufenden IT-Projekte. Moderiert Ressourcenkonflikte, strukturiert das Backlog und priorisiert strategische Projekte im Verhältnis zum operativen Tagesgeschäft.

> **Hinweis zur Governance-Unabhängigkeit (Minimalprinzip):** Security- und Datenschutz-Rollen prüfen eigene Umsetzungsentscheidungen zwingend im Vier-Augen-Prinzip. Bei Konflikten erfolgt immer der Einbezug eines weiteren IT-Teammitglieds oder der IT-Leitung.

### C. Operative Rollen (Das Tagesgeschäft)
*Rollen, die den täglichen Rhythmus der IT und den direkten Kontakt zu den Forschenden definieren.*

* **1st-Level Dispatcher (Rotierend):** Sichtet und priorisiert eingehende Tickets. Löst einfache Probleme direkt und eskaliert komplexe Fälle qualifiziert an die jeweiligen System-Owner.
* **Incident Commander:** Übernimmt bei Major-Incidents (z. B. Totalausfall Netzwerk oder Storage) die zentrale Einsatzleitung. Koordiniert das Troubleshooting-Team und kommuniziert Zwischenstände an Stakeholder.
* **Release Manager:** Koordiniert teamübergreifende Wartungsfenster und kommuniziert geplante Downtimes proaktiv an die betroffenen Professuren und Forschenden.
* **IT-Automation Architect:** Sucht proaktiv nach wiederkehrenden Admin-Prozessen im IT-Team und automatisiert diese mittels Scripting (Python, Bash, PowerShell) oder Tools wie Ansible.

> **Rotations-Regeln für operative Rollen:** Rotierende Rollen wechseln in einem festen Turnus (z. B. 4–6 Wochen). Es gibt keine direkte Wiederholung ohne Cool-down-Phase. Nach jeder Rotation findet eine strukturierte Übergabe statt.

### D. Research IT (Die Brückenbauer)
*Spezialrollen, die sehr nahe am Forschungsalltag der Psychologie operieren und direkte Schnittstellen zur Wissenschaft bilden.*

* **Data Engineering Lead:** Entwickelt und pflegt automatisierte ETL-Pipelines für Forschungsdaten. Berät Forschende beim Design von Datenbank-Architekturen und bei der Anbindung von Analyse-Tools.
* **Research-Tool Scout:** Beobachtet Entwicklungen bei Forschungssoftware, evaluiert Lösungen und testet Prototypen in Zusammenarbeit mit den Professuren.

### E. Service- & Erwartungsmanagement
* **Service Owner (optional rotierend):** Eine übergreifende Rolle für das gesamte IT-Service-Portfolio. Behält den Überblick über alle angebotenen IT-Services, klärt Erwartungen gegenüber Forschenden (Leistungsumfang, Reaktionszeiten, Zuständigkeiten) und koordiniert die Kommunikation. Die Rolle ist bewusst leichtgewichtig (ca. 10–15 %), zeitlich begrenzt und optional rotierend.

---

## 3. Rollen-Kompetenz-Verknüpfung im Plugin

Die Verbindung zwischen Rollen und Kompetenzen wird direkt im `redmine_subskills`-Plugin abgebildet. Für jede Rolle kann hinterlegt werden, welche Fach- und Sozialkompetenzen **wie wichtig** sind (Gewichtung 0–3). Daraus ergibt sich ein **Fit-Score** je Person und Rolle:

```
Fit-Score = Σ(Skill-Level × Gewichtung) / Σ(Max-Gewichtung × 5)
```

Der Fit-Score zeigt auf einen Blick, wer für welche Rolle am besten qualifiziert ist – und wo gezielte Weiterbildung sinnvoll wäre.

---

## 4. Der Verteilungs-Mechanismus (Wie teilen wir auf?)

1. **Skill-Assessment (Ist-Stand):** Jedes Teammitglied füllt seine Kompetenzmatrix in Redmine aus. Dadurch wird sichtbar, wer das technische Rüstzeug für welche System-Owner-Rolle hat.
2. **Interessen-Mapping (Soll-Stand):** Neben dem Können wird in Redmine abgefragt, welche Rolle ein Mitglied gerne ausfüllen oder erlernen möchte.
3. **Drafting (Der Rollen-Bazar):**
   * **Runde 1 (Die Pflicht):** Die kritischen System-Rollen (Netzwerk, Storage, IAM) werden zuerst mit Primaries und Secondaries besetzt.
   * **Runde 2 (Die Prozesse):** Security, Dokumentation und Support-Koordination werden vergeben.
   * **Runde 3 (Die Kür):** Automation, Innovation und Data-Engineering werden nach starken persönlichen Interessen verteilt.
4. **Das Rollen-Manifest:** Die Zuteilungen werden transparent in Redmine (Plugin-Ansicht) festgehalten. Das Manifest dokumentiert zwingend:
   * Das Zeitbudget (Richtwert in %)
   * Die Vertretungsregel (Primary/Secondary)
   * Die aktive Laufzeit bei Rotationsrollen
   * Eine halbjährliche Review-Pflicht (Passen die Hüte noch?)

### Vorteile für das Team
* **Verhinderung von Boreout/Burnout:** Niemand muss zu 100 % nur Tickets lösen.
* **Klare Ansprechpartner:** Forschende und Teammitglieder wissen genau, wer bei welchem Thema den „Lead-Hut" aufhat.
* **Stellvertretung by Design:** Durch das Primary/Secondary-Prinzip ist klar geregelt, wer einspringt, wenn der primäre Rollenträger ausfällt.
* **Transparente Prioritäten:** Implizite Entscheidungsfindung wird durch harte Prioritäten abgelöst (Incident > Support > System > Innovation).
* **Nachhaltige Arbeitslast:** Durch harte Zeitbudgets pro Rolle und Cool-down-Phasen bei Rotationen wird individueller Überlastung strukturell vorgebeugt.
