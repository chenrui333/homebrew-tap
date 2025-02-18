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

- `addons-linter`
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
- `backport`
- `balcony`
- `blade-formatter`
- `blue`
- `blueutil-tui`
- `blush`
- `box`
- `bpmnlint`
- `brighterscript-formatter`
- `brotab`
- `brunette`
- `btczee`
- `bytebox`
- `cai`
- `cargo-geiger`
- `cargo-readme`
- `cargo-sort`
- `cargo-spellcheck`
- `carton`
- `cf-terraforming`
- `cf-vault`
- `cloudlens`
- `cmdx`
- `cocainate`
- `codstts`
- `cohctl`
- `crlfmt`
- `cueimports`
- `darker`
- `dbee`
- `dela`
- `dockerfilegraph`
- `duster`
- `dvm`
- `emplace`
- `enola`
- `envtpl`
- `fancy-cat`
- `fex`
- `fixjson`
- `flow-editor`
- `flowgger`
- `fortitude`
- `gersemi`
- `gerust`
- `ghalint`
- `ghfetch`
- `gignr`
- `giq`
- `git-vain`
- `gitlabform`
- `gitman`
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
- `hf`
- `ip2d`
- `jetzig`
- `junit2html`
- `kaluma-cli`
- `kcl`
- `keyhunter`
- `leetgo`
- `lintnet`
- `llmdog`
- `llmpeg`
- `lola`
- `luaformatter`
- `lib-x`
- `libdivide`
- `mamediff`
- `mdbook-linkcheck`
- `mdsf`
- `mdslw`
- `mfa`
- `minisign`
- `mitex`
- `nocc`
- `ohy`
- `omnictl`
- `optivorbis`
- `otto`
- `oxbuild`
- `oxen`
- `pdfsyntax`
- `pgdog`
- `pike`
- `pipeform`
- `pluralith`
- `poop`
- `prefligit`
- `projectable`
- `public-ollama-finder`
- `pyink`
- `pyment`
- `r2md`
- `rabbitmq-message-ops`
- `rails-new`
- `reformat-gherkin`
- `remark-cli`
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
- `secco`
- `sheetui`
- `shiroa`
- `sig`
- `simdjzon`
- `sloctl`
- `spok`
- `surgeon`
- `tclint`
- `termtunnel`
- `terracove`
- `terraform-diff`
- `terraform-iam-policy-validator`
- `terraform`
- `terrap-cli`
- `terratag`
- `tfcmt`
- `tfmv`
- `tfreveal`
- `tfsort`
- `tftarget`
- `tftree`
- `tickrs`
- `tlint`
- `togomak`
- `toolctl`
- `tpm`
- `travelgrunt`
- `tun2proxy`
- `tuono`
- `twiggy`
- `usort`
- `vsg`
- `wallust`
- `werk`
- `xmlformatter`
- `yew-fmt`
- `yuque-dl`
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
