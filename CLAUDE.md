# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Overview

This is a **Killercoda scenario reference repository** — a collection of examples demonstrating every feature available when authoring interactive learning scenarios for the [Killercoda](https://killercoda.com/examples) platform. There is no build process; each top-level directory is a self-contained, deployable scenario.

Official documentation: https://killercoda.com/creators

## Scenario Structure

Every scenario is a directory with an `index.json` as its entry point. Content can be flat or organized into subdirectories per step.

**Flat (simple) layout:**
```
scenario-name/
├── index.json
├── intro.md
├── step1.md
└── finish.md
```

**Directory-per-step layout (for scripts):**
```
scenario-name/
├── index.json
├── intro/
│   ├── text.md
│   ├── foreground.sh
│   └── background.sh
├── step1/
│   ├── text.md
│   ├── verify.sh
│   ├── foreground.sh
│   └── background.sh
└── finish/
    └── text.md
```

## index.json Schema

```json
{
  "title": "Scenario Title",
  "description": "Optional subtitle shown in listings",
  "details": {
    "intro": {
      "title": "Optional intro title",
      "text": "intro.md",
      "foreground": "intro/foreground.sh",
      "background": "intro/background.sh"
    },
    "steps": [
      {
        "title": "Step Title",
        "text": "step1/text.md",
        "verify": "step1/verify.sh",
        "foreground": "step1/foreground.sh",
        "background": "step1/background.sh"
      }
    ],
    "finish": {
      "text": "finish.md"
    },
    "assets": {
      "host01": [
        { "file": "conf.yaml", "target": "~/", "chmod": "+x" }
      ]
    }
  },
  "backend": {
    "imageid": "ubuntu"
  }
}
```

### Backend image IDs

| `imageid` | Environment |
|-----------|-------------|
| `ubuntu` | Ubuntu (single node) |
| `kubernetes-kubeadm-1node` | Kubernetes single-node cluster |
| `kubernetes-kubeadm-2nodes` | Kubernetes two-node cluster (host01 + host02) |

### Scripts

- **`foreground.sh`** — runs in the terminal visible to the user; blocks until completion before the step loads
- **`background.sh`** — runs in the background silently (environment setup, package installs)
- **`verify.sh`** — called when the user clicks "Check"; must exit `0` to pass, non-zero to fail

### Assets

Files listed under `assets.host01` are uploaded to the environment before the scenario starts. Glob patterns are supported:

```json
{ "file": "*",          "target": "/dest" }   // top-level files
{ "file": "**",         "target": "/dest" }   // all files recursively
{ "file": "app/**/*.json", "target": "/dest" } // filtered recursive
```

## Markdown Content Features

Killercoda renders scenario `.md` files with extended syntax:

**Executable code block** (user clicks to run in terminal):
```
```plain
kubectl get pods
```{{exec}}
```

**Copy-to-clipboard block:**
```
```plain
some content
```{{copy}}
```

**Solution/tip dropdowns:**
```html
<details><summary>Solution</summary>

```plain
kubectl create namespace flower
```{{exec}}

</details>
```

**Embed images** (place files in `assets/` at repo root or scenario directory):
```markdown
![alt text](./assets/image.png)
```
