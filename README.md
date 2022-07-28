# actions - Reusable Actions for building Projects
This repository contains multiple reusable actions for my projects

## maven.yml
Builds a maven project w/o maven central and JDK 17

### Verify without Deployment
```yml
name: Maven Verify

on:
  push: # Ignore releases and main dev branch
    tags-ignore:
      - 'v*' 
    branches-ignore:
     - 'main'
  pull_request:
    types: [opened, synchronize, reopened]

  # Allows you to run this workflow manually from the Actions tab
  workflow_dispatch:

jobs:
  verify:
    uses: dfuchss/actions/.github/workflows/maven.yml@main
    with:
      deploy: false
      with-submodules: true
    secrets:
      OSSRH_USER: ${{secrets.OSSRH_USER}}
      OSSRH_TOKEN: ${{secrets.OSSRH_TOKEN}}
      GPG_KEY: ${{secrets.GPG_KEY}}
```

### Verify and Deploy to OSSRH
```yml
name: Maven Deploy

on:
  push:
    branches:
      - 'main' # Build the latest develop-SNAPSHOT
    paths:
      - '**/src/**'
      - '**/pom.xml'
      - 'pom.xml'

  # Allows you to run this workflow manually from the Actions tab
  workflow_dispatch:

jobs:
  publish:
    uses: dfuchss/actions/.github/workflows/maven.yml@main
    with:
      deploy: true
    secrets:
      OSSRH_USER: ${{secrets.OSSRH_USER}}
      OSSRH_TOKEN: ${{secrets.OSSRH_TOKEN}}
      GPG_KEY: ${{secrets.GPG_KEY}}
```

## sonarcloud.yml
Verify a maven project via sonarcloud

```yml
name: Sonar Cloud

on:
  push:
  pull_request:
    types: [opened, synchronize, reopened]

  # Allows you to run this workflow manually from the Actions tab
  workflow_dispatch:

jobs:
  sonarcloud:
    if: ${{ github.actor != 'dependabot[bot]' }} 
    uses: dfuchss/actions/.github/workflows/sonarcloud.yml@main
    with:
      with-submodules: true
    secrets:
      SONAR_TOKEN: ${{secrets.SONAR_TOKEN}}


```

