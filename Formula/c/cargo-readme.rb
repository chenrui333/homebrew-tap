class CargoReadme < Formula
  desc "Generate README.md from docstrings"
  homepage "https://github.com/webern/cargo-readme"
  url "https://github.com/webern/cargo-readme/archive/refs/tags/v3.4.1.tar.gz"
  sha256 "e71ebfead44907ea1573c6e4c177800808b06d6a5cbef2cd49d59a1934f9eb1f"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6b558c1ef3da2e6a72fb8363e606ef6fa40010b8dcdaa6c965240e2af1461738"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2c9af7dbe40a4ef8396d635f46ab25979adea5ba42ef0061c2e9da10efa8fe29"
    sha256 cellar: :any,                 arm64_linux:   "6ee3d2427bd6fc885d687ae114bad91ea412fdd5f1c81c349802390354d297fc"
    sha256 cellar: :any,                 x86_64_linux:  "537bf435e5e58aaa726d898a952151bcf20b8f6475705a7b2e4f3ae014aba760"
  end

  depends_on "rust" => :build

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/cargo-readme --version")

    (testpath/"Cargo.toml").write <<~TOML
      [package]
      name = "test"
      version = "0.1.0"
      edition = "2018"
    TOML

    (testpath/"src/lib.rs").write <<~RUST
      //! # Example
      //!
      //! ```
      //! assert_eq!(2 + 2, 4);
      //! ```
    RUST

    system bin/"cargo-readme", "readme", "--output", testpath/"README.md"
    assert_match "# test", (testpath/"README.md").read
  end
end
