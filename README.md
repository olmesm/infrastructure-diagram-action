# Infrastructure Diagram Action

This is a GitHub Action to create and commit infrastructure diagrams using the [Diagrams](https://diagrams.mingrammer.com/) tool. This deploy action is meant to be implemented as part of your PR process. This action will also add a review comment of the changes.

![Sample of Generated Infrastructure](<_documentation/diagrams/advanced_web_service_with_on-premise_(...).png>)

## Usage

Using the syntax defined in [Diagrams](https://diagrams.mingrammer.com/), create your infrastructure diagrams in the `input_dir` of your choice (default is \_documentation/diagrams) - [See this repo's example here](_documentation/diagrams/diagram.example.py)

Add the action to your workflow and the generated diagrams will be added to the PR branch once the workflow completes.

```yaml
# .github/workflows/generate-and-commit-diagrams.yml
name: Generate and commit diagrams
on:
  pull_request:
    branches: [main]

jobs:
  update-infrastructure-diagrams:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      - name: Infrastructure Diagrams
        uses: olmesm/infrastructure-diagram-action@v1
        with:
          github_token: ${{ secrets.GITHUB_TOKEN }}
          # input_dir: _documentation/diagrams
          # user_name: Bot
          # user_email: default@github-bot.com
          # commit_message: Diagrams generated with [Infrastructure Diagram Action](https://github.com/olmesm/infrastructure-diagram-action)
          # disable_review_comment: false
```

### Inputs

| Required | Input                  | Description                                                      |
| :------: | ---------------------- | ---------------------------------------------------------------- |
|   yes    | github_token           | Set a generated [github_token] for pushing to the remote branch. |
|          | debug                  | debug action                                                     |
|          | input_dir              | Set an input directory for processing.                           |
|          | user_name              | Set Git user.name                                                |
|          | user_email             | Set Git user.email                                               |
|          | commit_message         | Set a custom commit message with a triggered commit hash         |
|          | disable_review_comment | Disable posting a review comment                                 |

---

## Development

### Requires

- [docker](https://docker.com)

### Development

1. Create a test branch with the script `sh scripts/create-test-pr.sh`
1. Check the generated diagram matches [\_documentation/diagrams/diagram.template.png](_documentation/diagrams/diagram.template.png) to ensure no regression.

### Release

```bash
sh ./scripts/release.sh "release message"
```

## TODO

- [x] Improve speed by building and hosting a release image
- [ ] Add additional inputs listed in [action.yml](action.yml)

<!-- MARKDOWN REFERENCES -->

[github_token]: https://docs.github.com/en/actions/security-guides/automatic-token-authentication
