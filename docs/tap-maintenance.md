# Tap maintainer setup

## Bootstrap

For a new tap, start with Homebrew’s [tap creation guide](https://docs.brew.sh/How-to-Create-and-Maintain-a-Tap) and `brew tap-new --github-packages OWNER/TAP`. Do not run `tap-new` against this existing repository. To inspect this tap locally, use `brew tap chenrui333/tap`; use `chenrui333/tap/<formula>` when the short name may resolve elsewhere. Review tap code before trusting it.

For this repository, configure `HOMEBREW_GITHUB_API_TOKEN` as a GitHub Actions repository secret. The workflows that use it need a bot identity authorized to read Actions artifacts, maintain PR and branch state, and publish to this tap’s GHCR packages. For GHCR authentication from outside a package's linked workflow, see [GitHub Packages authentication](https://docs.github.com/en/packages/working-with-a-github-packages-registry/working-with-the-container-registry#authenticating-to-the-container-registry). Do not copy the secret into Git, local recipe files, or logs. Do not grant a fork or untrusted PR access to the publisher credential.

## Validate the formula publication path

1. Open one formula PR. [Build and Test Formulae](https://github.com/chenrui333/homebrew-tap/actions/workflows/tests.yml) tests the source head for its supported platforms. Check both the workflow conclusion and the actual build/test results, including uploaded failure artifacts if present.
2. After qualification, the [publisher](https://github.com/chenrui333/homebrew-tap/actions/workflows/publish.yml) uses `pr-pull` to publish bottles and push a bottle metadata commit. Check the `homebrew-tap/published-bottle-head` status on that commit; a successful run on the source head alone is not publication proof.
3. Wait for the [formula merge workflow](https://github.com/chenrui333/homebrew-tap/actions/workflows/formula-merge.yml). Confirm the PR merged and the recipe on `main` contains the expected bottle metadata. Do not manually add bottle hashes or merge a bottle-producing PR ahead of publication.
4. From a clean session without GHCR credentials, run `brew fetch --force --force-bottle chenrui333/tap/<formula>` on a platform with a published bottle. A successful authenticated upload does not make a new GHCR package public. If anonymous access fails, inspect the package visibility and obtain authorization before changing it.

## Rebuild a bottle

Use the [Rebottle workflow](https://github.com/chenrui333/homebrew-tap/actions/workflows/rebottle.yml) on `main`. It opens a revision PR and does not bypass source CI, publishing or merging. For a controlled validation, use the `hello` formula (see [the completed fixture rebuild](https://github.com/chenrui333/homebrew-tap/pull/14175)). Do not dispatch a new rebuild while a PR for that formula is already active.

```sh
gh workflow run rebottle.yml --repo chenrui333/homebrew-tap --ref main -f formula=hello
```

For a stalled publisher, use the [tap’s recovery policy](https://github.com/chenrui333/homebrew-tap/blob/main/AGENTS.md#publish-and-ci-recovery) and verify the exact head before dispatching anything.
