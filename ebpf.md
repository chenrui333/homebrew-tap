# eBPF Formula Candidates

Catalog of eBPF-related projects evaluated for packaging in this tap.

## Packaged

| Formula | Version | Language | Platform | License | PR |
|---------|---------|----------|----------|---------|-----|
| [pktz](https://github.com/immanuwell/pktz) | 0.3.0 | Go | Linux | MIT | #7070 |
| [ebpf-cache-profiler](https://github.com/Joseda8/ebpf-cache-profiler) | 0.1.0 | C++ | Linux | — | #7071 |
| [bpfvet](https://github.com/boratanrikulu/bpfvet) | 0.2.1 | Go | cross-platform | MIT | #7072 |
| [sakimori](https://github.com/bokuweb/sakimori) | 0.34.4 | Rust | cross-platform | MIT/Apache-2.0 | #7073 |
| [gecit](https://github.com/boratanrikulu/gecit) | 0.1.4 | Go | cross-platform | GPL-3.0 | #7074 |
| [olltop](https://github.com/evandhoffman/olltop) | 0.5.0 | Go | macOS/Linux | MIT | #7075 |
| [ghostscope](https://github.com/swananan/ghostscope) | 0.1.4 | Rust | Linux | GPL-3.0 | #7076 |
| [ingero](https://github.com/ingero-io/ingero) | 0.16.0 | Go | Linux | Apache-2.0 | #7077 |
| [logira](https://github.com/melonattacker/logira) | 0.1.0 | Go | Linux | Apache-2.0 | #7078 |
| [bpfviewer](https://github.com/tsint/bpfviewer) | 0.1.2 | Go | cross-platform | Apache-2.0 | #7079 |
| [eprofiler-tui](https://github.com/rogercoll/eprofiler-tui) | 0.2.0 | Rust | cross-platform | Apache-2.0 | #7080 |
| [azazel](https://github.com/beelzebub-labs/azazel) | 0.0.1 | Go | Linux | GPL-2.0 | #7081 |

## Not Packaged

### Nightly Rust + bpf-linker required

| Project | Description |
|---------|-------------|
| [syva](https://github.com/false-systems/syva) | eBPF LSM kernel enforcement for container isolation |
| [blackwall](https://github.com/xzcrpw/blackwall) | Adaptive eBPF/XDP firewall with AI honeypot (BSL 1.1 license) |
| [SNIpR](https://github.com/reinauer/SNIpR) | eBPF TLS router via sockmap |
| [vantage](https://github.com/erayack/vantage) | Per-tenant admission controller via tc hook |
| [profile-bee](https://github.com/zz85/profile-bee) | eBPF CPU profiler with flamegraph output |
| [ayaFlow](https://github.com/DavidHavoc/ayaFlow) | Network traffic analyzer via TC (K8s DaemonSet) |
| [litelb](https://github.com/naiello/litelb) | TCP/UDP load balancer via XDP |
| [rauha](https://github.com/false-systems/rauha) | Sandbox runtime for AI agents (complex workspace) |
| [erez](https://github.com/lifeisperfecto/erez) | Per-packet multipath routing |
| [secexit](https://github.com/secexit/secexit) | Egress firewall via cgroup connect4 hook (v0.1.0) |
| [raft-ebpf](https://github.com/nakame/raft-ebpf) | RAFT consensus with eBPF TC packet filter (3 commits) |
| [SPiCa](https://github.com/0xKirisame/SPiCa) | Rootkit detection via dual kernel observation (36 commits) |
| [rwatch](https://github.com/p-r-a-v-i-n/rwatch) | Real-time threat detection via eBPF hooks |
| [scx_horoscope](https://github.com/zampierilucas/scx_horoscope) | sched_ext CPU scheduler based on astrology (Linux 6.12+) |
| [tailscale-vips-loopback](https://github.com/nebulis-proxmox/tailscale-vips-loopback) | Tailscale VIP loopback routing |

### Needs clang/bpftool at build time (no pre-compiled BPF objects)

| Project | Description |
|---------|-------------|
| [kwatch-ebpf](https://github.com/ismajl-ramadani/kwatch-ebpf) | Kernel process monitor (Go, go generate) |
| [systing](https://github.com/josefbacik/systing) | System tracer for scheduling/syscalls (Rust, v1.0.0) |
| [eghostbuster](https://github.com/fracappa/eghostbuster) | Ghost resource cleanup (Go, v0.2.0) |
| [foxing](https://codeberg.org/aenertia/foxing) | Filesystem replication engine (Rust, v0.9.5-rc2) |
| [owLSM](https://github.com/Cybereason-Public/owLSM) | LSM agent with Sigma rules (C/C++, Docker build, v0.3.0) |
| [rstat](https://github.com/overyonder/rstat) | System monitor via scheduler probes (Rust, Nix build) |
| [siper](https://github.com/fksvs/siper) | XDP IP blacklist firewall (Go, needs clang) |
| [bng](https://github.com/codelaboratoryltd/bng) | Broadband network gateway (Go, BSL 1.1, v0.4.0) |
| [ebpf-traffic-meter](https://github.com/PawseySC/ebpf-traffic-meter) | Per-user network traffic monitor (C, 6 commits) |
| [netfence](https://github.com/danthegoodman1/netfence) | eBPF cgroup/TC filter daemon with DNS allowlisting (Go, no releases) |
| [ci-agent](https://github.com/tuananh/ci-agent) | eBPF egress audit for CI (C, 1 commit) |
| [turn-bpf](https://github.com/ivanmtech/turn-bpf) | TURN protocol XDP accelerator (Rust/C, 2 commits) |
| [Tachi](https://github.com/AtoZ132/Tachi) | Heap tracing for memory leaks (C/C++, 6 commits) |
| [hyperion-xdp](https://github.com/nevinshine/hyperion-xdp) | XDP DPI security engine (C/Go, needs clang) |
| [cilium-policypilot](https://github.com/prabhakaran-jm/cilium-policypilot) | Cilium policy generator from Hubble flows (Go, 14 commits) |
| [huatuo](https://github.com/ccfos/huatuo) | OS observability platform (Go/C, Docker deployment, v2.2.0) |
| [ebpf-fix-latency-tool](https://github.com/epam/ebpf-fix-latency-tool) | FIX protocol latency measurement (C, v0.0.9) |
| [rust-bee-ns](https://github.com/ivanmtech/rust-bee-ns) | DNS racing via XDP (Rust/C, 2 commits) |
| [uif](https://github.com/msune/uif) | Untagged network subinterfaces via TCX (Go/C, v0.2.0) |
| [psc](https://github.com/loresuso/psc) | Process scanner via eBPF iterators (Go, v0.3.2) |
| [ebpf-profiling](https://github.com/nielsdekoeijer/ebpf-profiling) | USDT pipeline profiling example (C++, 5 commits) |
| [xgotop](https://github.com/ozansz/xgotop) | Go runtime visualizer via uprobes (C, arm64 only) |

### Nightly Rust + bpf-linker (continued)

| Project | Description |
|---------|-------------|
| [Avislya](https://github.com/JackySu/Avislya) | GFW DNS filter via eBPF (4 commits) |
| [AINFTP](https://github.com/GHOryy5/AINFTP) | XDP gradient aggregation for AI training (40 commits) |

### Not a standalone CLI / poor Homebrew fit

| Project | Description | Reason |
|---------|-------------|--------|
| [trace-ktls](https://github.com/dorser/trace-ktls) | kTLS plaintext capture | Inspektor Gadget runtime, not standalone |
| [krakenguard](https://github.com/krakenguard-ebpf/krakenguard) | BPF bytecode policy enforcement | Multi-component pipeline, Docker/LLVM/KLEE |
| [honeybeepf-llm](https://github.com/honeybee-studio/honeybeepf-llm) | LLM observability agent | K8s DaemonSet, no releases |
| [kpod-metrics](https://github.com/pjs7678/kpod-metrics) | Pod kernel metrics collector | K8s DaemonSet (Kotlin/Spring Boot) |
| [nfs-flamegraph](https://github.com/4rivappa/nfs-flamegraph) | NFS flamegraph generator | Shell scripts, 1 commit |
| [cilium_analyzer](https://github.com/manmohanmirkar123/cilium_analyzer) | Cilium manifest checker | Python script, 3 commits |
| [bpftime-go](https://github.com/tylerflint/bpftime-go) | Userspace eBPF Go library | Library, not CLI tool |
| [l2radar](https://github.com/msune/l2radar) | L2 network neighbor monitor | Docker-orchestrated system |
| [Aegis](https://github.com/pushkar-gr/Aegis) | Zero Trust firewall (Go+Rust) | Two-daemon Docker Compose system |
| [egressor](https://github.com/phonginreallife/egressor) | K8s data transfer cost intelligence | Multi-service platform (Docker Compose, 7 commits) |
| [micromize](https://github.com/micromize-dev/micromize) | Container security hardening | Needs Inspektor Gadget CLI |
| [Hackathon-eBPF-2025](https://github.com/patos-ufscar/Hackathon-eBPF-2025) | K8s pod scheduler via sched_ext | Hackathon project, no releases |
| [aetherless](https://github.com/ankitkpandey1/aetherless) | Serverless orchestrator (CRIU+eBPF) | Complex multi-component system |

## Potential Future Candidates

Projects that could be packaged if they add releases or fix build requirements:

| Project | Blocker | Notes |
|---------|---------|-------|
| [systing](https://github.com/josefbacik/systing) | needs bpftool | Rust, v1.0.0, MIT — closest to packageable |
| [owLSM](https://github.com/Cybereason-Public/owLSM) | Docker build env | C/C++, v0.3.0, GPL-2.0 |
| [eghostbuster](https://github.com/fracappa/eghostbuster) | needs clang/bpftool | Go, v0.2.0, Apache-2.0 |
| [foxing](https://codeberg.org/aenertia/foxing) | needs clang/bpftool | Rust, v0.9.5-rc2, GPL-2.0 |
| [siper](https://github.com/fksvs/siper) | needs clang | Go, no releases, GPL-3.0 |
| [bng](https://github.com/codelaboratoryltd/bng) | needs clang, BSL 1.1 | Go, v0.4.0 |
| [ellanetworks/core](https://github.com/ellanetworks/core) | needs investigation | Go, v1.10.2, Apache-2.0, 5G core with eBPF data plane |

## Not Yet Evaluated

| Project | Notes |
|---------|-------|
| [h0x0er/ebpf-cover](https://github.com/h0x0er/ebpf-cover) | |
| [m4rba4s/Aegis-eBPF](https://github.com/m4rba4s/Aegis-eBPF) | |
| [mentat-is/slurp-ebpf](https://github.com/mentat-is/slurp-ebpf) | |
| [ruota/Metric-Net-Agent](https://github.com/ruota/Metric-Net-Agent) | |
| [softcane/KubeAttention](https://github.com/softcane/KubeAttention) | |
| [haidang-infosec/phantom-grid](https://github.com/haidang-infosec/phantom-grid) | |
| [zrougamed/cerberus](https://github.com/zrougamed/cerberus) | |
| [tokiwa-software/feeze](https://github.com/tokiwa-software/feeze) | |
| [davidcoles/xvs](https://github.com/davidcoles/xvs) | |
| [takehaya/xdperf](https://github.com/takehaya/xdperf) | |
| [networkedsystemsIITB/flash](https://github.com/networkedsystemsIITB/flash) | |
| [VladimiroPaschali/eBPF-InXpect](https://github.com/VladimiroPaschali/eBPF-InXpect) | |
| [linnix-os/linnix](https://github.com/linnix-os/linnix) | |
| [gma1k/snake-ebpf](https://github.com/gma1k/snake-ebpf) | |
| [ShahbozbekH/Slither](https://github.com/ShahbozbekH/Slither) | |
| [cakturk/dnsbpf](https://github.com/cakturk/dnsbpf) | |
