# actions - Reusable Actions for building Projects
This repository contains multiple reusable actions for my projects

You can find all details on the different actions in the Wiki for more information.


## How to use your own copy
**If you want to use the actions of this repository, you can directly take a look into the wiki.**

If you want to create a fork in order to have your own repository, proceed with the following steps:

1. Create the fork (CI of docs might fail or will not run. This is ok at the current step!)
2. Create a secret for GitHub Actions called `PAT_TOKEN` that contains a personal access token that has access to public repositories.
3. Create an empty wiki page in the wiki of your fork.
4. Activate all actions and trigger the `docs.yml` action to create the wiki entries.
