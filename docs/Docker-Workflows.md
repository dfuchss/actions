## docker.yml
Build and Publish a Docker Image

```yml
name: Docker with Push

on:
  push:
    branches:
      - 'main' # Build the latest develop-SNAPSHOT

  # Allows you to run this workflow manually from the Actions tab
  workflow_dispatch:

jobs:
  publish:
    uses: dfuchss/actions/.github/workflows/docker.yml@main
    with:
      image-name: "myimage"
      push: true
```
