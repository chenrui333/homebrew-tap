class R2md < Formula
  desc "Entire codebase to single markdown or pdf file"
  homepage "https://github.com/skirdey-inflection/r2md"
  url "https://static.crates.io/crates/r2md/r2md-0.4.0.crate"
  sha256 "210d369b0c90f48c4c4987eca0583421ee5620af4dd5ea3b5bb0fadd0ee4eefc"
  license "Apache-2.0"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "60eca3797330f4137ec84574b469fec9f41db6d2c1ef004f9357faeaeaf9b83b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "08c5772f4b9545f4eee45d8d58b3d8b5361961c2be05990c34f390219fbbcbe9"
    sha256 cellar: :any_skip_relocation, ventura:       "a07b4c3c722ea49948ebc6c9839f87c4b8430c3228049fdffeef682f08bc8fb3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5f6b2751417275f7551493d5e9a31778ce47b40d03fa96065f8a5d253b34c477"
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
