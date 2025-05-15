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
    uses: <<REPO>>/.github/workflows/maven.yml@main
    with:
      deploy: false
      with-submodules: true
    secrets:
      CENTRAL_USER: ${{secrets.CENTRAL_USER}}
      CENTRAL_TOKEN: ${{secrets.CENTRAL_TOKEN}}
      GPG_KEY: ${{secrets.GPG_KEY}}
```

### Verify and Deploy to CENTRAL
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
    uses: <<REPO>>/.github/workflows/maven.yml@main
    with:
      deploy: true
    secrets:
      CENTRAL_USER: ${{secrets.CENTRAL_USER}}
      CENTRAL_TOKEN: ${{secrets.CENTRAL_TOKEN}}
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
    uses: <<REPO>>/.github/workflows/sonarcloud.yml@main
    with:
      with-submodules: true
    secrets:
      SONAR_TOKEN: ${{secrets.SONAR_TOKEN}}
```

## maven-update.yml
Update Dependencies and Update Versions

:warning: It is important that the project either uses the revision property or has a single version property. Otherwise, the version will not be updated correctly.

* You can configure the optional property `create-tag` if you want to disable the creation of a tag. 
* You can configure the optional property `auto-digit` if you want to change the default digit that shall be incremented on release. Default is Patch (2.1.0 -> 2.1.1). Possible values are `Major`, `Minor` and `Patch`.

```yml
name: Maven Dependency Updates

on:
  schedule:
    - cron: "00 11 * * 2"

  # Allows you to run this workflow manually from the Actions tab
  workflow_dispatch:

jobs:
  update:
    uses: <<REPO>>/.github/workflows/maven-update.yml@main
    secrets:
      # Needs to be a personal access token to push as a certain user; otherwise actions won't be triggered.
      PAT: ${{ secrets.PAT }}
```

## maven-release.yml
Create new Maven Release (only commits tags & branch and updates versions)

:warning: It is important that the project either uses the revision property or has a single version property. Otherwise, the version will not be updated correctly.

* You can configure the optional property `auto-digit` if you want to change the default digit that shall be incremented on release. Default is Patch (2.1.0 -> 2.1.1). Possible values are `Major`, `Minor` and `Patch`.

```yml
name: Maven Release

on:
  # Allows you to run this workflow manually from the Actions tab
  workflow_dispatch:

jobs:
  update:
    uses: <<REPO>>/.github/workflows/maven-release.yml@main
    secrets:
      # Needs to be a personal access token to push as a certain user; otherwise actions won't be triggered.
      PAT: ${{ secrets.PAT }}
```

## maven-manual-release.yml
Create a manual release based on user input.

:warning: It is important that the project either uses the revision property or has a single version property. Otherwise, the version will not be updated correctly.

* You can configure the optional property `auto-digit` if you want to change the default digit that shall be incremented on release. Default is Patch (2.1.0 -> 2.1.1). Possible values are `Major`, `Minor` and `Patch`.

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
  release:
    uses: <<REPO>>/.github/workflows/maven-manual-release.yml@main
    secrets:
      # Needs to be a personal access token to push as a certain user; otherwise actions won't be triggered.
      PAT: ${{ secrets.PAT }}
    with:
      release-version: ${{ github.event.inputs.release-version }}
      next-version: ${{ github.event.inputs.next-version }}
```
