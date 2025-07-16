class YewFmt < Formula
  desc "Code formatter for the Yew framework"
  homepage "https://github.com/its-the-shrimp/yew-fmt"
  url "https://github.com/its-the-shrimp/yew-fmt/archive/refs/tags/v0.6.3.tar.gz"
  sha256 "ff045c8bdd2e03a2e59dd7c58fb80abf6d45cd9f1267641c4aa296ca944112e1"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6130d350eef0ef179a58efdd67057d9b2d0f88500d6bb8b92514780c328fc476"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6df1aa5e2293e6621053b59f53c4aaab1ae9cb7b73699c3dfbc409b02d040f10"
    sha256 cellar: :any_skip_relocation, ventura:       "d222f0bafbc9982fe5734f8aab1c582f497cc4d3aada92ba65ed11df83d05a56"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3a81bf6df247204659a5e2a8c007b2a577586ab0ffdeef7ce765057db7f16b59"
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
