class R2md < Formula
  desc "Entire codebase to single markdown or pdf file"
  homepage "https://github.com/skirdey-inflection/r2md"
  url "https://static.crates.io/crates/r2md/r2md-0.4.3.crate"
  sha256 "30ee2003522b6e5dde293d55f1f19be68fe70031d1019114b4d9a802befec10a"
  license "Apache-2.0"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2e60b21641dadfcb7246ababdadd463008a473ee31d8c76301cea2260d5ff75f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "de43574801543bf97b45e25115e9865082349196c4c98e35c353c7e03daf2083"
    sha256 cellar: :any_skip_relocation, ventura:       "3aebb7fd36879000b8c36d597d942f0fb4e6e796a3dc3f576760df0067dbb15a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "12bb39471bf0a3284294441c1a3193cde02dcc5d00d9781cbf498bdc50417bed"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "openssl@3"
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/r2md --version")

    (testpath/"test.rs").write <<~RUST
      fn main() {
          println!("Hello, world!");
      }
    RUST

    output = shell_output("#{bin}/r2md #{testpath}")
    assert_match "# r2md Streaming Output", output
  end
end
