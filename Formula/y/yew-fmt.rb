class YewFmt < Formula
  desc "Code formatter for the Yew framework"
  homepage "https://github.com/its-the-shrimp/yew-fmt"
  url "https://github.com/its-the-shrimp/yew-fmt/archive/refs/tags/v0.6.3.tar.gz"
  sha256 "ff045c8bdd2e03a2e59dd7c58fb80abf6d45cd9f1267641c4aa296ca944112e1"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "eb580ee4b0e9a02f5063bd46ba58d771129dd8007c9d94cf4aade36a45fb7694"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7da6df27af14516c57ab60d7c53fe00c13f42320a3bc511ea373f2272ace6357"
    sha256 cellar: :any_skip_relocation, ventura:       "15e8fa5228f2e5ca3e0be8f5218dbe027bdb174413061eff5f2b820822fecbb9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "66955dbedadeaa1c58e6b948f7bbd7777950c72c5d886272c29cf03f27475311"
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
