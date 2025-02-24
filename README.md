# homebrew-tap

This tap is setup for several reasons:

- Formulae cannot be included into core for license (`BSL` for example), notability or stable release reasons
- The tap is also well suited to test the upstream patches, as it is using same formula build/test process as homebrew-core.
- Better alias support

## Contributing

Issues and PRs are welcome! Whether you’ve found a bug, have a feature request, or want to contribute code, please feel free to open an issue or submit a pull request. Your contributions help improve this tap for everyone.

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
- `await`
- `awk-language-server`
- `awless`
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
- `castor`
- `cf-terraforming`
- `cf-vault`
- `cloudlens`
- `cmdx`
- `cocainate`
- `codstts`
- `cohctl`
- `container2wasm`
- `crlfmt`
- `cueimports`
- `darker`
- `dbee`
- `dbin`
- `dblab`
- `dela`
- `dockerfilegraph`
- `duster`
- `dvm`
- `emoj`
- `emplace`
- `enola`
- `envtpl`
- `evans`
- `fancy-cat`
- `ferret`
- `fex`
- `fiona`
- `fixjson`
- `fkill-cli`
- `flow-editor`
- `flowgger`
- `fortitude`
- `gersemi`
- `gerust`
- `ghalint`
- `ghfetch`
- `gignr`
- `giq`
- `git-chglog`
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
- `gtree`
- `gtts`
- `hasha-cli`
- `hcldump`
- `hclgrep`
- `hclq`
- `hello`
- `hellwal`
- `hf`
- `horusec`
- `hostctl`
- `ip2d`
- `jetzig`
- `jira-cli`
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
- `mail-deduplicate`
- `mamediff`
- `mdbook-linkcheck`
- `mdsf`
- `mdslw`
- `mermaid-cli`
- `mfa`
- `minisign`
- `mitex`
- `mln`
- `mmemoji`
- `ni`
- `nocc`
- `np`
- `npkill`
- `nvrs`
- `ohy`
- `omekasy`
- `omnictl`
- `optivorbis`
- `otto`
- `oxbuild`
- `oxen`
- `pdfsyntax`
- `percollate`
- `pgdog`
- `pike`
- `pipeform`
- `plandex`
- `pls`
- `pluralith`
- `poop`
- `precompress`
- `prefligit`
- `projectable`
- `public-ollama-finder`
- `pyink`
- `pyment`
- `qnm`
- `r2md`
- `rabbitmq-message-ops`
- `rails-new`
- `ramda-cli`
- `rasterio`
- `reformat-gherkin`
- `refurb`
- `remark-cli`
- `resinator`
- `revanced-cli`
- `rpds-py`
- `rslocal`
- `rustfilt`
- `sarif-tools`
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
- `shopify-cli`
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
- `tgpt`
- `tickrs`
- `tlint`
- `togomak`
- `token-cli`
- `toolctl`
- `tpm`
- `travelgrunt`
- `tun2proxy`
- `tuono`
- `twiggy`
- `usort`
- `venom`
- `vercel-serve`
- `vsg`
- `wallust`
- `werk`
- `xmlformatter`
- `yew-fmt`
- `yosay`
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
