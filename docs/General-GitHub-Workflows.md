## github-release.yml
Create a new GitHub Release (Aggregate logs from "Maven Dependency Updates" action)

```yml
name: Create Release
on:
  workflow_dispatch:
  push:
    # Publish `v1.2.3` tags as releases.
    tags:
      - v*

jobs:
  release:
    uses: <<REPO>>/.github/workflows/github-release.yml@main
    
```
