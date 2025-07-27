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
- `amoco`
- `aoc-cli`
- `apkeep`
- `arduino-language-server`
- `arp-scan-rs`
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
- `blindfold`
- `blue`
- `blueutil-tui`
- `blush`
- `botkube`
- `box`
- `brighterscript-formatter`
- `brotab`
- `brunette`
- `btczee`
- `bunster`
- `bytebox`
- `c4go`
- `cai`
- `cargo-benchcmp`
- `cargo-careful`
- `cargo-clone`
- `cargo-geiger`
- `cargo-readme`
- `carton`
- `castor`
- `cello`
- `certok`
- `cf-vault`
- `cf2pulumi`
- `checkpwn`
- `cloudlens`
- `cmdx`
- `cocainate`
- `codstts`
- `cohctl`
- `config-file-validator`
- `container2wasm`
- `critcmp`
- `crlfmt`
- `cueimports`
- `darker`
- `dbee`
- `dbin`
- `ddev`
- `dela`
- `docker-debug`
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
- `go-envsubst`
- `fast-cli`
- `fast-xml-parser`
- `ferret`
- `fex`
- `firectl`
- `fixjson`
- `fjira`
- `fkill-cli`
- `flow-editor`
- `flowgger`
- `fortran-linter`
- `foy`
- `fsociety`
- `gemini-cli`
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
- `gobgp`
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
- `holo-cli`
- `horusec`
- `hostctl`
- `huber`
- `humioctl`
- `hygg`
- `iftree`
- `illa`
- `imgcat`
- `incus-compose`
- `infraspec`
- `ip2d`
- `ips`
- `jaggr`
- `jetzig`
- `jiggy`
- `jl`
- `jplot`
- `jsonl-graph`
- `junit2html`
- `kaluma-cli`
- `karmor`
- `kbst`
- `kcl`
- `keyhunter`
- `klepto`
- `knip`
- `kpt`
- `krs`
- `kt`
- `kube-role-gen`
- `kube2pulumi`
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
- `mermaid-cli`
- `meteor`
- `mfa`
- `minisign`
- `mitex`
- `mln`
- `mmemoji`
- `mnamer`
- `molotov`
- `mpfshell`
- `mqtt-cli`
- `nanodbc`
- `narr`
- `nest-cli`
- `netscanner`
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
- `rshell`
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
- `strimzi-kafka-cli`
- `summon`
- `surgeon`
- `tantivy-cli`
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
- `xcpkg`
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
