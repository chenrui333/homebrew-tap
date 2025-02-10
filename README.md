# homebrew-tap

This tap is setup for several reasons:

- Formulae cannot be included into core for license (`BSL` for example), notability or stable release reasons
- The tap is also well suited to test the upstream patches, as it is using same formula build/test process as homebrew-core.
- Better alias support

Issues and PRs are welcome!

## Installation

```bash
# tap the repo
brew tap chenrui333/tap

# formula
brew install <tool>

# cask
brew install --cask <tool>
```

## package list

### Formulae

<!-- FORMULAE-LIST-START -->
<details>
<summary>Formula List</summary>

- `aiac`
- `alacritty`
- `amoco`
- `aoc-cli`
- `apkeep`
- `asciinema`
- `balcony`
- `blueutil-tui`
- `blush`
- `brotab`
- `btczee`
- `bytebox`
- `cargo-geiger`
- `cargo-readme`
- `cargo-sort`
- `cargo-spellcheck`
- `carton`
- `cf-terraforming`
- `cf-vault`
- `cfnctl`
- `codstts`
- `dvm`
- `emplace`
- `envtpl`
- `fancy-cat`
- `fex`
- `flow-editor`
- `flowgger`
- `fortitude`
- `gerust`
- `giq`
- `git-vain`
- `glsl-analyzer`
- `go-junit-report`
- `goboscript`
- `gofakeit`
- `gommit`
- `grcov`
- `hcldump`
- `hcledit`
- `hclgrep`
- `hclq`
- `hello`
- `hellwal`
- `jetzig`
- `junit2html`
- `keyhunter`
- `koji`
- `llmdog`
- `lola`
- `libdivide`
- `mdbook-linkcheck`
- `minisign`
- `mitex`
- `ohy`
- `omnictl`
- `otto`
- `oxbuild`
- `pike`
- `pipeform`
- `pluralith`
- `poop`
- `projectable`
- `public-ollama-finder`
- `rails-new`
- `resinator`
- `rpds-py`
- `rslocal`
- `rustfilt`
- `sato`
- `satty`
- `sdl_image`
- `sdl_mixer`
- `sdl_net`
- `sdl_ttf`
- `seamstress`
- `shiroa`
- `sig`
- `simdjzon`
- `surgeon`
- `termtunnel`
- `terracove`
- `terraform-cleaner`
- `terraform-diff`
- `terraform-iam-policy-validator`
- `terraform`
- `terrap-cli`
- `terratag`
- `tf-summarize`
- `tfprovidercheck`
- `tfreveal`
- `tfsort`
- `tftarget`
- `tftree`
- `threatcl`
- `togomak`
- `tpm`
- `travelgrunt`
- `tun2proxy`
- `tuono`
- `twiggy`
- `wallust`
- `yor`
- `zero`
- `zig@0.11`
- `zig@0.12`
- `ziggy`
- `zigscient`
- `zlint`
- `zware`

</details>
<!-- FORMULAE-LIST-END -->

## Known Issues

### Package creation for personal accounts

I learned it in a hard way that there is no way to change the default package creation visibility from private to public.
However, for organization accounts, it is feasible to update the default visibility setting for package creation (see [this thread](https://github.com/orgs/community/discussions/65931#discussioncomment-7613551))
