class Macfan < Formula
  desc "Terminal UI for controlling Mac fan speeds via SMC on Apple Silicon"
  homepage "https://github.com/raminsharifi/MacFanControl"
  url "https://github.com/raminsharifi/MacFanControl/archive/1669877f01365fd1d948085ccbf4627691153c1b.tar.gz"
  version "0.1.0"
  sha256 "27df0c33e94c2297a0d2eb7d9941e9947241b144e2191fcfe7e13a2c067b2528"
  license "MIT"
  head "https://github.com/raminsharifi/MacFanControl.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    rebuild 2
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d682fc633de95d6c929e36475be79c650c8eb397828e28569d1d1b26195263e6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7a98f6a8dd629fa68723cfcffed13fbf723e04e8445010ab77f8893d5445f5d6"
  end

  depends_on "rust" => :build
  depends_on :macos

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    require "open3"

    # FIXME: Upstream does not expose a version command; replace this with a version assertion when available.
    output, status = Open3.capture2e(bin/"macfan", "--not-a-real-option")
    refute_predicate status, :success?
    assert_match "not-a-real-option", output
  end
end
