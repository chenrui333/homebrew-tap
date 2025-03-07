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

- `abc`
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
- `certok`
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
- `eas-cli`
- `emoj`
- `emplace`
- `enola`
- `enry`
- `envtpl`
- `evans`
- `fast-xml-parser`
- `ferret`
- `fex`
- `fiona`
- `fixjson`
- `fkill-cli`
- `flow-editor`
- `flowgger`
- `fortran-linter`
- `foy`
- `fsociety`
- `gerust`
- `ghalint`
- `ghfetch`
- `gignr`
- `giq`
- `git-chglog`
- `git-vain`
- `gitlabform`
- `gitman`
- `glom`
- `glsl-analyzer`
- `go-junit-report`
- `goboscript`
- `gofakeit`
- `goimports-reviser`
- `gommit`
- `goodls`
- `grcov`
- `grmon`
- `gtree`
- `gtts`
- `hasha-cli`
- `hauler`
- `hcldump`
- `hclgrep`
- `hclq`
- `hello`
- `hellwal`
- `hf`
- `horusec`
- `hostctl`
- `infraspec`
- `ip2d`
- `jaggr`
- `jetzig`
- `jplot`
- `junit2html`
- `kaluma-cli`
- `kcl`
- `keyhunter`
- `knip`
- `kt`
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
- `meteor`
- `mfa`
- `minisign`
- `mitex`
- `mln`
- `mmemoji`
- `mnamer`
- `mob`
- `nest-cli`
- `nhost`
- `ni`
- `nocc`
- `nom`
- `np`
- `npkill`
- `nvrs`
- `ohy`
- `omekasy`
- `omnictl`
- `optivorbis`
- `otel-cli`
- `otto`
- `oxbuild`
- `oxen`
- `papis`
- `pdfsyntax`
- `percollate`
- `pgdog`
- `pike`
- `pingu`
- `pipeform`
- `plandex`
- `playerctl`
- `pls`
- `pluralith`
- `poop`
- `precompress`
- `preevy`
- `prefligit`
- `projectable`
- `public-ollama-finder`
- `pyink`
- `pyment`
- `pyp`
- `qnm`
- `r2md`
- `rabbitmq-message-ops`
- `rails-new`
- `ramda-cli`
- `rang`
- `rasterio`
- `readmeai`
- `reformat-gherkin`
- `refurb`
- `remark-cli`
- `resinator`
- `revanced-cli`
- `rpds-py`
- `rslocal`
- `rtop`
- `rustfilt`
- `sarif-tools`
- `sato`
- `satty`
- `saw`
- `sdl_image`
- `sdl_mixer`
- `sdl_net`
- `sdl_ttf`
- `seamstress`
- `secco`
- `sgpt`
- `sheetui`
- `sherif`
- `shiroa`
- `shopify-cli`
- `sig`
- `simdjzon`
- `sloctl`
- `spok`
- `statoscope`
- `surgeon`
- `tclint`
- `termtunnel`
- `terracove`
- `terraform-diff`
- `terraform-iam-policy-validator`
- `terraform-module-versions`
- `terraform`
- `terrap-cli`
- `terratag`
- `tetrigo`
- `tfcmt`
- `tfmv`
- `tfreveal`
- `tfsort`
- `tftarget`
- `tftree`
- `tickrs`
- `timetrace`
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
- `vitepress`
- `vsg`
- `wallust`
- `werk`
- `xmlformatter`
- `yew-fmt`
- `yosay`
- `yuque-dl`
- `go-zzz`
- `zero`
- `zig@0.11`
- `zig@0.12`
- `zig@0.13`
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
