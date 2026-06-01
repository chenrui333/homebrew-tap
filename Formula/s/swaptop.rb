class Swaptop < Formula
  desc "TUI for monitoring swap usage"
  homepage "https://github.com/luis-ota/swaptop"
  url "https://github.com/luis-ota/swaptop/archive/refs/tags/v1.0.6t.tar.gz"
  version "1.0.6t"
  sha256 "d0315222a844debbb4f11bb0d9658a1fd4f691e3169dec47bd97d76268fa9d03"
  license "MIT"
  head "https://github.com/luis-ota/swaptop.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any, arm64_linux:  "edb9c6242d3d1997481a04c230ef93c10852d34a14ab8bee392ff18876219752"
    sha256 cellar: :any, x86_64_linux: "2462c17911d8175138c11d1e3dc971037e18db60e7acfe2e8f7b9e150dc82415"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on :linux

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    if ENV["HOMEBREW_GITHUB_ACTIONS"]
      output = shell_output("#{bin}/swaptop --version 2>&1", 101)
      assert_match "failed to initialize terminal", output
    end
  end
end
