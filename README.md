# Infrastructure Diagram Action

This is a GitHub Action to create and commit infrastructure diagrams using the [Diagrams](https://diagrams.mingrammer.com/) tool. This deploy action is meant to be implemented as part of your PR process. This action will also add a review comment of the changes.

## Usage

```yaml
jobs:
  update-infrastruture-diagrams:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      - name: Infrastructure Diagrams
        uses: olmesm/infrastructure-diagram-action@latest
        with:
          github_token: ${{ secrets.GITHUB_TOKEN }}
```

### Inputs

| Input                       | Description                                                                                                                                         | Default Value                                                                                                    |
| --------------------------- | --------------------------------------------------------------------------------------------------------------------------------------------------- | ---------------------------------------------------------------------------------------------------------------- |
| **[required]** github_token | Set a generated [GITHUB_TOKEN](https://docs.github.com/en/actions/security-guides/automatic-token-authentication) for pushing to the remote branch. |                                                                                                                  |
| debug                       | debug action                                                                                                                                        |
| input_dir                   | Set an input directory for processing.                                                                                                              | \_documentation/diagrams                                                                                         |
| user_name                   | Set Git user.name                                                                                                                                   | Bot                                                                                                              |
| user_email                  | Set Git user.email                                                                                                                                  | default@github-bot.com                                                                                           |
| commit_message              | Set a custom commit message with a triggered commit hash                                                                                            | Diagrams generated with [Infrastructure Diagram Action](https://github.com/olmesm/infrastructure-diagram-action) |
| disable_review_comment      | Disable posting a review comment                                                                                                                    |

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

- [ ] Improve speed by building and hosting a release image
- [ ] Add additional inputs in [action.yml](action.yml)
