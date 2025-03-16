class YewFmt < Formula
  desc "Code formatter for the Yew framework"
  homepage "https://github.com/its-the-shrimp/yew-fmt"
  url "https://github.com/its-the-shrimp/yew-fmt/archive/refs/tags/v0.6.tar.gz"
  sha256 "bc295f6b4a323e29fc978157f6ae7907612ea55e4c437d793a53aa8e3d35dc10"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "82914877544cedc1493d726bddf9514dead77ca0805f785c53ae5b1c0a8a53d8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5ba6ed131f8cbb2f455f3239fa2a2462abbc8eb615584b68e3cc2465a6191a51"
    sha256 cellar: :any_skip_relocation, ventura:       "8f2234cd922483f97dd4e663ac1ad1d845d9f34de2f7593362e3406bef8788e4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6e9d3661f6de018a670ad1d4c2c704a9c0d355608e90ca76b400f2cee034e3ac"
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
