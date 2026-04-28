class CargoReadme < Formula
  desc "Generate README.md from docstrings"
  homepage "https://github.com/webern/cargo-readme"
  url "https://github.com/webern/cargo-readme/archive/refs/tags/v3.3.1.tar.gz"
  sha256 "0044a2b199aa3ef8ed473bbec7af32a5a00579f755414e0c55707617fc2951b0"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "48c7e2125963f83ce33057ac80738afee24cb0c1f8c7476a326c8f9eb2fad861"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b1dbf2f8a2a90a62797b70d4fea81595bb474cc48f5b62d342317ceb76f44c8b"
    sha256 cellar: :any_skip_relocation, ventura:       "1553597ea0be120b73067399748c9a3028a0ee34622f5860568c6c4b3d73b31e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8c976f1a17d13172c5da4fc6549d12dc7d2e73e5d7b3af0a1600ca47ba4caf4b"
  end

  depends_on "rust" => :build

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
