class CargoReadme < Formula
  desc "Generate README.md from docstrings"
  homepage "https://github.com/webern/cargo-readme"
  url "https://github.com/webern/cargo-readme/archive/refs/tags/v3.3.2.tar.gz"
  sha256 "fa533037c28912f7ac09a06a04f3710a163a5461d7428d440ac701cbfc791312"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "347e366b4377569c9dd0208038479da6ea77ae5f20163072c91ff9379d5a1ff9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "502fda991ee05fa366a7a15f1860521b36feb60895441ac27b308e5d441e7749"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "49593b1b777668bb1e70d572e461b4b9c7ea4352310be6f1d996c0edde7c9e06"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f00eb874f7bbac06029cc0eb7e988149ac4b19549721bc308534f2328cc799b2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3be099e773df1868a498d161debdb5af88f700e7d5be5f330340086737bcd54b"
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
