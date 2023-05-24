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

## maven-update.yml
Update Dependencies and Update Versions

:warning: It is important that the project either uses the revision property or has a single version property. Otherwise, the version will not be updated correctly.

```yml
name: Maven Dependency Updates

on:
  schedule:
    - cron: "00 11 * * 2"

  # Allows you to run this workflow manually from the Actions tab
  workflow_dispatch:

jobs:
  update:
    uses: dfuchss/actions/.github/workflows/maven-update.yml@main
    secrets:
      # Needs to be a personal access token to push as a certain user; otherwise actions won't be triggered.
      PAT: ${{ secrets.PAT }}
```

## maven-release.yml
Create new Maven Release (only commits tags & branch and updates versions)

:warning: It is important that the project either uses the revision property or has a single version property. Otherwise, the version will not be updated correctly.

```yml
name: Maven Release

on:
  # Allows you to run this workflow manually from the Actions tab
  workflow_dispatch:

jobs:
  update:
    uses: dfuchss/actions/.github/workflows/maven-release.yml@main
    secrets:
      # Needs to be a personal access token to push as a certain user; otherwise actions won't be triggered.
      PAT: ${{ secrets.PAT }}
```

## maven-manual-release.yml
Create a manual release based on user input.

:warning: It is important that the project either uses the revision property or has a single version property. Otherwise, the version will not be updated correctly.

```yml
name: Maven Release (Manual)

on:
  # Allows you to run this workflow manually from the Actions tab
  workflow_dispatch:
    inputs:
      release-version:
        type: string
        description: The version for release. E.g., "1.2.3"
        required: true
      next-version:
        type: string
        description: The version after release. E.g., "2.0.0-SNAPSHOT"
        required: true
jobs:
  update:
    uses: dfuchss/actions/.github/workflows/maven-release.yml@main
    secrets:
      # Needs to be a personal access token to push as a certain user; otherwise actions won't be triggered.
      PAT: ${{ secrets.PAT }}
    with:
      release-version: ${{ github.event.inputs.release-version }}
      next-version: ${{ github.event.inputs.next-version }}
```
