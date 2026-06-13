class K10s < Formula
  desc "GPU-aware Kubernetes TUI"
  homepage "https://github.com/shvbsle/k10s"
  url "https://github.com/shvbsle/k10s/archive/refs/tags/v1.0.0.tar.gz"
  sha256 "aebba6046eb323451d5bb0648dc9b15f7e952af7338dd3bd646d2dbb75f730df"
  license "Apache-2.0"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9034bcc879b9d4ee05fd510c6aa6ecf81dcb19e099390ef0672f0b806abd35af"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1cefc02abf02596dea137b4a9d7ff5ee80bb6b0a3435755dab10bace02aee6c4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3729e15ecb0a3974f43b8e38ae75f50dbba824a9cc1ef7c2a36955e2ea6f7a45"
    sha256 cellar: :any,                 arm64_linux:   "6a3ca11acad072cbd48c2b0bcfff21bbc8a3c2817156c6f4abcb846ab2466273"
    sha256 cellar: :any,                 x86_64_linux:  "59b65be11cb87c23168b1a93365dd73215e6902e2226f8ec7ae7b9092480cb1b"
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
