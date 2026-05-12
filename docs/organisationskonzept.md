# IT-Organisationskonzept

_Stand: Mai 2026 · Verantwortlich: IT-Abteilung_

---

Dieses Dokument beschreibt das IT-Organisationskonzept basierend auf dem Kerngedanken: **Anforderungen → Systeme ← IT-Organisation**.

Wir kümmern uns als „Organisation" um die „Systeme", welche den übergeordneten „Anforderungen" gerecht werden sollten. Das Modell gliedert sich in diese drei Hauptschichten:

## 1. Anforderungen (Requirements)

Die generellen Anforderungen, welche die Ausgestaltung der Systeme diktieren, stammen primär aus den drei Kernbereichen der Hochschule:
- **Lehre**
- **Forschung**
- **Betrieb**

Diese Bereiche fordern von den Systemen die Einhaltung von drei wesentlichen Zieldimensionen:

### A. Reglemente (Compliance & Normative Rahmenbedingungen)
- **Gesetze** (inklusive z. B. Datenschutz DSG/DSGVO)
- **Verträge**
- **Institutionelle Vorgaben** (Spezifisch: UZH + Psych)

### B. Funktionalität (Zweck und Datenfokus)
Die Funktionalität ist stark datenzentriert und bildet die direkte Schnittstelle zu den Forschenden. Genau an diesem Schnittpunkt von reiner IT-Infrastruktur und angewandter Wissenschaft ist die Funktion der **„Research IT"** angesiedelt:
- **Erhebung** (Datensammlung)
- **Management** (Datenverwaltung)
- **Analyse** (Datenauswertung)
- **Transfer** (Datenübertragung)

### C. Wirtschaftlichkeit (Ökonomische & Qualitative Rahmenbedingungen)
- **Zuverlässigkeit** (z. B. Betriebssicherheit, Business Continuity)
- **Qualität**
- **Kosteneffizienz**

---

## 2. Systeme

Im Zentrum des Konzepts stehen die **Systeme**. Diese setzen sich aus vier Kernbausteinen zusammen:
1. **Dienst** (Services)
2. **Abläufe** (Prozesse)
3. **Doku** (Dokumentation)
4. **Infrastruktur**

Die übergeordnete Aufgabe dieser Systeme ist es, die oben genannten zentralen Anforderungen massgeblich zu erfüllen.

### Die Rolle des System-Owners
Da ein System zwingend betrieben und weiterentwickelt werden muss, braucht es Personen, die für die Erfüllung einer geforderten Funktionalität verantwortlich sind: die **System-Owner**.
Ein System-Owner betreut und entwickelt sein System ganzheitlich und trägt die volle **Lifecycle-Verantwortung** – von der Planung über den Betrieb und die zukünftige Ausrichtung bis hin zu Übergabe oder Entsorgung.

---

## 3. IT-Organisation (Umsetzung)

Um sicherzustellen, dass die Systeme den hohen Anforderungen (Funktionalität, Compliance, Wirtschaftlichkeit) gerecht werden, kümmern wir uns als Organisation um deren Bereitstellung und Pflege. Die IT-Organisation stützt sich dabei auf zwei zwingende Pfeiler:
1. **Gute betriebliche Strukturen**
2. **Gute Entwicklung**

### Entwicklung (Planung & Veränderung)
Die Entwicklung spannt sich von einer *High-Level*-Flughöhe bis hinunter zum *Low-Level*:
- **„Vision"** (Langfristige Ausrichtung)
- **Strategie**
- **Projekte**
- **Tuning** (Optimierung)

### Betrieb (Erhalt & Unterstützung)
Der Betrieb stellt das laufende Tagesgeschäft sicher:
- **Wartung**
- **Administration**
- **„Support"**, welcher sich weiter untergliedert in:
  - *Anleitungen* und *Schulungen* (Befähigung der Nutzer)
  - *1. Hilfe* (First-Level-Support)
  - *2nd Level* (Second-Level-Support)
  - *Bugs & Failures* (Fehlerbehebung und Ausfallmanagement)

---

## 4. Basis: Organisation (Stakeholder & Gremien)

Den Boden des Konzepts bildet die institutionelle Organisation, in der die IT eingebettet ist. Typische Akteure und Schnittstellen sind hierbei:
- **Lehrstühle**
- **IV**
- **ITK**
- **ZKA**
- **UZH-ZI** (Zentrale Informatik der Universität Zürich)

---

## 5. Abgeleitete Kompetenzprofile und das Redmine-Skill-Plugin

Aus diesem übergreifenden Modell lassen sich direkte Anforderungen an die Kompetenzen (Skills) der IT-Teammitglieder ableiten. Um die Systeme gemäss den Anforderungen stabil zu betreiben und weiterzuentwickeln, braucht es konkrete Fähigkeiten in den beschriebenen Handlungsfeldern.

**Das `redmine_subskills`-Plugin** macht diese Kompetenzen sichtbar: Es erlaubt jedem Teammitglied eine strukturierte Selbsteinschätzung direkt in Redmine — und zeigt der IT-Leitung auf einen Blick, wo Stärken liegen und wo Lücken bestehen.

**A. Für die Erfüllung der Anforderungen durch die Systeme:**
- **Compliance & Reglemente:** Wissen zu Datenschutz (DSG/DSGVO), Vertragsmanagement und internen Richtlinien (UZH).
- **Funktionalität & Daten (Fokus Research IT):** Skills in Datenmanagement, Data Engineering (ETL, Transfer) und Analyse (R, Python) kombiniert mit einem tiefen Verständnis für wissenschaftliche Methoden und den Forschungslebenszyklus.
- **Wirtschaftlichkeit, Security & Qualität:** Operative Informationssicherheit (Cybersecurity), IT-Risk Management, Qualitätsmanagement, Service Level Management, Zuverlässigkeitstechnik (SRE), Business Continuity Management, Kostenbewusstsein bei der Ressourcenplanung.

**B. Für den Betrieb (Erhalt & Unterstützung):**
- **Infrastruktur & Administration:** Server- und Netzwerkadministration, Virtualisierung, Wartung von Hardware/Software.
- **Support & Kommunikation:** Empathie und Didaktik für Schulungen/Anleitungen, lösungsorientiertes Handeln im 1st und 2nd Level Support, Incident-Management.

**C. Für die Entwicklung (Planung & Veränderung):**
- **Strategie & Architektur:** Technologische Weitsicht („Vision"), Fähigkeit zu High-Level Systemarchitektur, Innovationsbereitschaft.
- **Plattform-Entwicklung:** Full-Stack- oder Backend-Entwicklung, Containerisierung (Docker, Kubernetes), Aufbau und Integration von APIs sowie die Bereitstellung hochverfügbarer IT-Plattformen.
- **Projektmanagement:** Strukturierte Planung und Umsetzung von IT-Projekten.
- **Tuning & Low-Level:** Tiefe technische Spezialisierung (z. B. Performance-Optimierung, Scripting, Code-Refactoring).
