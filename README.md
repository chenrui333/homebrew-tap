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
- `ai-context`
- `aiac`
- `aiken`
- `alacritty`
- `algolia`
- `amoco`
- `aoc-cli`
- `apkeep`
- `arduino-language-server`
- `asciinema`
- `asm-lsp`
- `asmfmt`
- `astro-language-server`
- `autoflake`
- `autotag`
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
- `botkube`
- `box`
- `brighterscript-formatter`
- `brotab`
- `brunette`
- `btczee`
- `bytebox`
- `cai`
- `cargo-careful`
- `cargo-clone`
- `cargo-geiger`
- `cargo-readme`
- `cargo-sort`
- `carton`
- `castor`
- `cello`
- `certok`
- `cf-vault`
- `cloudlens`
- `cmdx`
- `cocainate`
- `codstts`
- `cohctl`
- `config-file-validator`
- `container2wasm`
- `crlfmt`
- `cueimports`
- `darker`
- `dbee`
- `dbin`
- `dela`
- `docker-debug`
- `dockerfilegraph`
- `doit`
- `duster`
- `dvm`
- `eas-cli`
- `elastop`
- `emoj`
- `emplace`
- `enola`
- `enry`
- `envtpl`
- `fast-cli`
- `fast-xml-parser`
- `ferret`
- `fex`
- `firectl`
- `fixjson`
- `fkill-cli`
- `flow-editor`
- `flowgger`
- `fortran-linter`
- `foy`
- `fsociety`
- `gemini-cli`
- `gerust`
- `ghalint`
- `ghfetch`
- `gignr`
- `giq`
- `git-chglog`
- `git-vain`
- `gitlabform`
- `gitman`
- `gitmux`
- `glom`
- `glsl-analyzer`
- `go-junit-report`
- `goboscript`
- `gofakeit`
- `goimports-reviser`
- `gommit`
- `goodls`
- `gowebly`
- `graphtage`
- `grcov`
- `grmon`
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
- `humioctl`
- `iftree`
- `infraspec`
- `ip2d`
- `ips`
- `jaggr`
- `jetzig`
- `jl`
- `jplot`
- `jsonl-graph`
- `junit2html`
- `kaluma-cli`
- `kbst`
- `kcl`
- `keyhunter`
- `klepto`
- `knip`
- `kpt`
- `krs`
- `kt`
- `ktop`
- `kube-role-gen`
- `kubeseal-convert`
- `kwt`
- `leetgo`
- `leveldb-cli`
- `lintnet`
- `llmdog`
- `llmpeg`
- `lola`
- `luaformatter`
- `lib-x`
- `libdivide`
- `mail-deduplicate`
- `mamediff`
- `markpdf`
- `matcha`
- `mcman`
- `mdbook-linkcheck`
- `mdsf`
- `mdslw`
- `mender-cli`
- `mermaid-cli`
- `meteor`
- `mfa`
- `minisign`
- `mitex`
- `mln`
- `mmemoji`
- `mnamer`
- `narr`
- `nest-cli`
- `netfetch`
- `ngtop`
- `nhost`
- `ni`
- `nocc`
- `np`
- `npkill`
- `nvrs`
- `ohy`
- `omekasy`
- `omnictl`
- `optivorbis`
- `osmar`
- `otelgen`
- `otto`
- `oxbuild`
- `oxen`
- `papis`
- `pdfsyntax`
- `pencode`
- `percollate`
- `perfops`
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
- `prefligit`
- `projectable`
- `proto2yaml`
- `protoc-gen-lint`
- `protodep`
- `protodot`
- `protolock`
- `public-ollama-finder`
- `pyink`
- `pyment`
- `pyp`
- `quicssh-rs`
- `r2md`
- `rabbitmq-message-ops`
- `rails-new`
- `ramda-cli`
- `rang`
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
- `scholar`
- `scrt`
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
- `speedscope`
- `speedtest`
- `spok`
- `spotifydl`
- `statoscope`
- `style-dictionary`
- `summon`
- `surgeon`
- `tclint`
- `tenderly`
- `termsvg`
- `termtunnel`
- `terracove`
- `terraform-diff`
- `terraform`
- `terrap-cli`
- `terratag`
- `tetrigo`
- `tfmcp`
- `tfreveal`
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
- `unused-deps`
- `usort`
- `venom`
- `vercel-serve`
- `vgo`
- `vitepress`
- `vsg`
- `wallust`
- `wedl`
- `werk`
- `xmlformatter`
- `yajsv`
- `yeetfile`
- `yew-fmt`
- `yosay`
- `yuque-dl`
- `go-zzz`
- `zero`
- `zig@0.11`
- `zig@0.12`
- `zig@0.13`
- `ziggy`
- `ziglint`
- `zigscient`
- `zware`

</details>
<!-- FORMULAE-LIST-END -->

## Known Issues

### Package creation for personal accounts

I learned it in a hard way that there is no way to change the default package creation visibility from private to public.
However, for organization accounts, it is feasible to update the default visibility setting for package creation (see [this thread](https://github.com/orgs/community/discussions/65931#discussioncomment-7613551))
