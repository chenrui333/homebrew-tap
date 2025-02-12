class YewFmt < Formula
  desc "Code formatter for the Yew framework"
  homepage "https://github.com/its-the-shrimp/yew-fmt"
  url "https://github.com/its-the-shrimp/yew-fmt/archive/refs/tags/v0.5.4.tar.gz"
  sha256 "682d84bfce52766fab32b3d401c312f7a520766d58157e845dd00c377e510edd"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "51dfc90ef317a24062342d6e0baa7f3691352a28932638bb5efbf808bcdffb29"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "dbc1d8205b8356e05b9614881567ba921a12113c7e2b64ea4e2bc5e69908f8ab"
    sha256 cellar: :any_skip_relocation, ventura:       "31bf343d31d5b7208a743c1741b1b1d928613c44ca69c77945dd9da974d524da"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "720265ece629fc8d0ef8cdbbb065d7d9f9fd4df107c13df767669cc3d85bc4f0"
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
