class YewFmt < Formula
  desc "Code formatter for the Yew framework"
  homepage "https://github.com/its-the-shrimp/yew-fmt"
  url "https://github.com/its-the-shrimp/yew-fmt/archive/refs/tags/v0.6.3.tar.gz"
  sha256 "ff045c8bdd2e03a2e59dd7c58fb80abf6d45cd9f1267641c4aa296ca944112e1"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2c9b1ac1ad7ec7273f636b0ef02cab491218e95fefae17f224e69c7d5d2345a3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b9514db437396a8cc22b553f1c360332c668d6bcfc3391fba8d4c9cef031addb"
    sha256 cellar: :any,                 arm64_linux:   "43058c6a28954282abba8ac1ae73422271eef9a24f6b1b8c51d8ecc15d4e3f3f"
    sha256 cellar: :any,                 x86_64_linux:  "37c13aa638f2e377c3c40b178054a71d1c9350d37fcaa0bb9685e3c4d686e7cf"
  end

  depends_on "rust" => [:build, :test]

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    # Use the `rust` formula's rustfmt; installing a rustup toolchain needs network access.
    ENV.prepend_path "PATH", formula_opt_bin("rust")

    assert_match version.to_s, shell_output("#{bin}/yew-fmt --version")

    (testpath/"test.rs").write <<~RUST
      fn main() {
          yew::html! {<div id={"foo"} class="bar"></div>}
      }
    RUST

    formatted = shell_output("#{bin}/yew-fmt --emit stdout #{testpath}/test.rs")
    assert_match(%r{<div id="foo" class="bar" ?/>}, formatted)
  end
end
