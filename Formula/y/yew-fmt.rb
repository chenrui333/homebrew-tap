class YewFmt < Formula
  desc "Code formatter for the Yew framework"
  homepage "https://github.com/its-the-shrimp/yew-fmt"
  url "https://github.com/its-the-shrimp/yew-fmt/archive/refs/tags/v0.5.4.tar.gz"
  sha256 "682d84bfce52766fab32b3d401c312f7a520766d58157e845dd00c377e510edd"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e679576abf77071e419434117ba03c854f661bb7df51293e9bcf70616ec3cf4f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8b389f923be11758bd79c7b32dd99f0f39b8f93296e4ec204ecfde894487a225"
    sha256 cellar: :any_skip_relocation, ventura:       "2653dd056049fe26093f2b822bc80fd8158e4ead8671654001b48feca94a42a0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ce677d3bcca880650a632b922899055776957e48fc263418edf938f20a321237"
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
