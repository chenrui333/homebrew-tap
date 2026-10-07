class StylanceCli < Formula
  desc "Scoped CSS style imports for rust"
  homepage "https://github.com/basro/stylance-rs"
  url "https://github.com/basro/stylance-rs/archive/refs/tags/v0.8.4.tar.gz"
  sha256 "3f059f07d321e65ea301f0c27947230f4c8eb196c0e15e620d180c3af6535fd7"
  license "MIT"
  head "https://github.com/basro/stylance-rs.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "845a893bd5fbac58a7298992850af75bb369d7dff58dc17a6cc381a10e416ac6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "692f14e17ba1ca4a6131046c035750dff41d946be5fd72eb79790154a3f60365"
    sha256 cellar: :any,                 arm64_linux:   "047c34c9a5e4f0a2f08c40ba0f74fe897c4c72b10f202956dfa5529d7fc0a9f0"
    sha256 cellar: :any,                 x86_64_linux:  "36c597368745dfa1810e17f0ff248c95f7eb21af94dbc4fa82374e935130bf4a"
  end

  depends_on "rust" => :build

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    system "cargo", "install", *std_cargo_args(path: "stylance-cli")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/stylance --version")

    (testpath/"Cargo.toml").write <<~TOML
      [package]
      name = "stylance-test"
      version = "0.1.0"
      edition = "2021"

      [dependencies]
    TOML

    (testpath/"src/button.module.css").write <<~CSS
      .button {
        background-color: blue;
        color: white;
      }
    CSS

    system bin/"stylance", "--output-file", "all.css", testpath
    assert_match "background-color: blue;", (testpath/"all.css").read
  end
end
