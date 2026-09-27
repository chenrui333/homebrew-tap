class Swaptop < Formula
  desc "TUI for monitoring swap usage"
  homepage "https://github.com/luis-ota/swaptop"
  url "https://github.com/luis-ota/swaptop/archive/refs/tags/v1.0.6t.tar.gz"
  version "1.0.6t"
  sha256 "d0315222a844debbb4f11bb0d9658a1fd4f691e3169dec47bd97d76268fa9d03"
  license "MIT"
  version_scheme 1
  head "https://github.com/luis-ota/swaptop.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any, arm64_linux:  "9645bb9636e0f68de04f608e431e10527d5c5258b0097a2920a16cb4dd4ba887"
    sha256 cellar: :any, x86_64_linux: "ebc1382036ea76a68e8233cf795e489ec014f83e26720a57ee312fd3ad5a62df"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on :linux

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    # FIXME: Upstream does not expose a version command; replace this with a version assertion when available.
    output = shell_output("#{bin}/swaptop --version 2>&1", 101)
    assert_match "failed to initialize terminal", output
  end
end
