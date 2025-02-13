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

- `ai-context`
- `aiac`
- `aiken`
- `alacritty`
- `alejandra`
- `amoco`
- `aoc-cli`
- `apkeep`
- `arduino-language-server`
- `asciinema`
- `asm-lsp`
- `asmfmt`
- `astro-language-server`
- `autoflake`
- `autotools-language-server`
- `awk-language-server`
- `azure-pipelines-language-server`
- `bacon-ls`
- `balcony`
- `blade-formatter`
- `blue`
- `blueutil-tui`
- `blush`
- `box`
- `brighterscript-formatter`
- `brotab`
- `brunette`
- `btczee`
- `bytebox`
- `cargo-geiger`
- `cargo-readme`
- `cargo-sort`
- `cargo-spellcheck`
- `carton`
- `cf-terraforming`
- `cf-vault`
- `cloudlens`
- `codstts`
- `crlfmt`
- `cueimports`
- `darker`
- `dbee`
- `duster`
- `dvm`
- `emplace`
- `envtpl`
- `fancy-cat`
- `fex`
- `fixjson`
- `flow-editor`
- `flowgger`
- `fortitude`
- `gersemi`
- `gerust`
- `giq`
- `git-vain`
- `glsl-analyzer`
- `go-junit-report`
- `goboscript`
- `gofakeit`
- `goimports-reviser`
- `gommit`
- `grcov`
- `hcldump`
- `hclgrep`
- `hclq`
- `hello`
- `hellwal`
- `jetzig`
- `junit2html`
- `jupytext`
- `kcl`
- `keyhunter`
- `koji`
- `llmdog`
- `lola`
- `lib-x`
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
- `sheetui`
- `shiroa`
- `sig`
- `simdjzon`
- `soft-serve`
- `surgeon`
- `tclint`
- `termtunnel`
- `terracove`
- `terraform-diff`
- `terraform-iam-policy-validator`
- `terraform`
- `terrap-cli`
- `terratag`
- `tfreveal`
- `tfsort`
- `tftarget`
- `tftree`
- `tickrs`
- `togomak`
- `tpm`
- `travelgrunt`
- `tun2proxy`
- `tuono`
- `twiggy`
- `wallust`
- `werk`
- `yew-fmt`
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
