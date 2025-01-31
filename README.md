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
- `asciinema`
- `balcony`
- `blueutil-tui`
- `blush`
- `btczee`
- `bytebox`
- `carton`
- `cf-terraforming`
- `cf-vault`
- `cfnctl`
- `codstts`
- `dvm`
- `emplace`
- `fancy-cat`
- `fex`
- `flow`
- `fortitude`
- `gerust`
- `git-vain`
- `glsl-analyzer`
- `go-junit-report`
- `goboscript`
- `hcldump`
- `hcledit`
- `hclgrep`
- `hello`
- `hellwal`
- `jetzig`
- `junit2html`
- `keyhunter`
- `koji`
- `lola`
- `libdivide`
- `minisign`
- `mitex`
- `omnictl`
- `otto`
- `oxbuild`
- `pike`
- `pluralith`
- `poop`
- `projectable`
- `public-ollama-finder`
- `rails-new`
- `resinator`
- `rpds-py`
- `rslocal`
- `sato`
- `satty`
- `seamstress`
- `shiroa`
- `sig`
- `simdjzon`
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
- `tun2proxy`
- `wallust`
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
