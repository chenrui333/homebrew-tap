class K10s < Formula
  desc "GPU-aware Kubernetes TUI"
  homepage "https://github.com/shvbsle/k10s"
  url "https://github.com/shvbsle/k10s/archive/refs/tags/v1.0.0.tar.gz"
  sha256 "aebba6046eb323451d5bb0648dc9b15f7e952af7338dd3bd646d2dbb75f730df"
  license "Apache-2.0"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ef9edfcd5eda678d3b37e225978a7b9935438fd3773f1dde8aa1ccbb67ac98ee"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "51796b95013dfa985d6590a00f8b422ff7cccde6a8ebd0dd47a4e6a3042e01f0"
    sha256 cellar: :any,                 arm64_linux:   "437dfe6badf2678b7d66990e8aed2289e60b9a2c095702d0de099888d51e57af"
    sha256 cellar: :any,                 x86_64_linux:  "2e0fa74fa28f4e410b68edb21f21dd2fa813e2b8348d214579009a7374b4e8c5"
  end

  depends_on "rust" => :build

  deny_network_access!

  def fetch
    # The release lockfile still lists dependencies the stub `tui` crate no longer declares.
    system "cargo", "update", "--workspace"
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    # Upstream 1.0.0 TUI has no CLI flags yet; add a version flag for Homebrew's test.
    inreplace "src/crates/tui/src/main.rs", <<~RUST, <<~RUST
      fn main() {
          println!("k10s tui");
      }
    RUST
      fn main() {
          if std::env::args().any(|arg| arg == "--version" || arg == "-V") {
              println!("k10s #{version}");
              return;
          }

          println!("k10s tui");
      }
    RUST

    system "cargo", "install", *std_cargo_args(path: "src/crates/tui")
    mv bin/"tui", bin/"k10s"
  end

  test do
    assert_equal "k10s #{version}\n", shell_output("#{bin/"k10s"} --version")
    assert_equal "k10s tui\n", shell_output(bin/"k10s")
  end
end
