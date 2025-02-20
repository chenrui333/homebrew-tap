class R2md < Formula
  desc "Entire codebase to single markdown or pdf file"
  homepage "https://github.com/skirdey-inflection/r2md"
  url "https://static.crates.io/crates/r2md/r2md-0.4.3.crate"
  sha256 "30ee2003522b6e5dde293d55f1f19be68fe70031d1019114b4d9a802befec10a"
  license "Apache-2.0"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5b077247c6074ec75bb8a8581a535fe8cd04eb2cc2137cc566247336a580b9e6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "18747b39173e7b58b7ba0ac3a5807d63182e7ccfbd28bdd422137f1fc1194ee7"
    sha256 cellar: :any_skip_relocation, ventura:       "d5bb7fd474c838d68c787abbfb89ca5e986bd4903842b336cd8dbcad8709170f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bf4ff20d68b9cc7763ff4f787a925881bd0bb1c66eb79682fdecfcf1ab5e126c"
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
