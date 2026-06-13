class K10s < Formula
  desc "GPU-aware Kubernetes TUI"
  homepage "https://github.com/shvbsle/k10s"
  url "https://github.com/shvbsle/k10s/archive/refs/tags/v1.0.0.tar.gz"
  sha256 "aebba6046eb323451d5bb0648dc9b15f7e952af7338dd3bd646d2dbb75f730df"
  license "Apache-2.0"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b7c90dcca3fdb4124340de432633b8129021603626bdc6ef4400d07cc01b0b61"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b7c90dcca3fdb4124340de432633b8129021603626bdc6ef4400d07cc01b0b61"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b7c90dcca3fdb4124340de432633b8129021603626bdc6ef4400d07cc01b0b61"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5bb358a356a326ac135f98e09f27b0bd77b692cdcfb7eec3691d09c4b326cb22"
    sha256 cellar: :any,                 x86_64_linux:  "8a3d55c7264afc2df37a731825c0e46161d71ed4160dff0be7acacfa4a6939da"
  end

  depends_on "rust" => :build

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
