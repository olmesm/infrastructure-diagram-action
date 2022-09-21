# Infrastructure Diagram Action

Diagram as Code allows you to track the architecture diagram changes in any version control system. Uses [Diagrams](https://diagrams.mingrammer.com/) under the hood.

---

## Development

### Requires

- [docker](https://docker.com)

```bash
# Build the image
docker build -t infrastructure-diagram-action src/.

# Run the image
docker run --rm -it -v $(pwd)/diagrams:/usr/src/app/diagrams -v $(pwd)/.git:/usr/src/app/.git -w /usr/src/app infrastructure-diagram-action
```

## TODO

- [ ] Improve speed by building and hosting a release image
- [ ] Add additional inputs in [action.yml](action.yml)
