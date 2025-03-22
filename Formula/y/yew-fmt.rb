class YewFmt < Formula
  desc "Code formatter for the Yew framework"
  homepage "https://github.com/its-the-shrimp/yew-fmt"
  url "https://github.com/its-the-shrimp/yew-fmt/archive/refs/tags/v0.6.1.tar.gz"
  sha256 "63859b8bd4f6ebd7d7df891935f73fb7ecd61f58994528e8f1514e7ad249dea0"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f545f09b8ecd38d533183e0443d7ef4135d15295dd49fcdc62f23379212d7917"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d009f700abc39cd8081ee54e51474da27d2532359e34f468c3fb26cfc43b8be6"
    sha256 cellar: :any_skip_relocation, ventura:       "d5ec632f5f9a18840ee83fb0c61d2a078d0b9a4229241f1091735777e489a411"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1af2faeafb73a113a8766012bd6164b35ca4a5a67116496a2ae169567e318fb0"
  end

  depends_on "rust" => :build
  depends_on "rustup" => :test

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    # Show that we can use a different toolchain than the one provided by the `rust` formula.
    # https://github.com/Homebrew/homebrew-core/pull/134074#pullrequestreview-1484979359
    ENV.prepend_path "PATH", Formula["rustup"].bin
    system "rustup", "default", "beta"
    system "rustup", "set", "profile", "minimal"
    system "rustup", "component", "add", "rustfmt"

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
