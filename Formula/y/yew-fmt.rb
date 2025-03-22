class YewFmt < Formula
  desc "Code formatter for the Yew framework"
  homepage "https://github.com/its-the-shrimp/yew-fmt"
  url "https://github.com/its-the-shrimp/yew-fmt/archive/refs/tags/v0.6.1.tar.gz"
  sha256 "63859b8bd4f6ebd7d7df891935f73fb7ecd61f58994528e8f1514e7ad249dea0"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a061c0da4d6b7ed1de91398a8f5cd1f958cb1b52692ef7dcdf2cbb2364f40faf"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5ccb42ae706116e84779c56db8a5f0f3d5a5b471c8dcc8a0c6075400a8e60d7c"
    sha256 cellar: :any_skip_relocation, ventura:       "128ebb4fde08370938f01e992589ea42c7d0eeded21c5b7f387b28bc332dac4a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "55817fd96c47a8e1b8089eab7a9217bb8e4f26207cccc8d78126fecb72580847"
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
