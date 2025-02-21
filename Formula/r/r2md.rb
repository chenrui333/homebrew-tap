class R2md < Formula
  desc "Entire codebase to single markdown or pdf file"
  homepage "https://github.com/skirdey-inflection/r2md"
  url "https://static.crates.io/crates/r2md/r2md-0.4.4.crate"
  sha256 "a825301857fbc1d40b98910a1b71c08798ebf752ec0dec34b2e726199b448f92"
  license "Apache-2.0"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f72fe8677904c528ec03a7154d0e80e5ccbd22699cdb05ba22a26830e0fb28bb"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "34e4fa8b2ee5a7081c6734620bc4af3b4789b0890329d9be65b7faa877c08620"
    sha256 cellar: :any_skip_relocation, ventura:       "2ffbf959861bb9a3d0309220d89bdb33614c9f6eb5c366214777b8bf313070db"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "28d5a6d2a5ab15b6896a92675aa8901ec23dae0698c2226073fa64f4542b76a5"
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
