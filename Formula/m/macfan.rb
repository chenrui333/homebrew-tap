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
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "55a985f83666de14dedbf80016724939805e8ee7d270e3abadecf26819f03c9b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2302af43f4d8d16cd921ade91e0fee938ac5c47d0d268af8059b41a3f762cc84"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f4c863778819ca94a13422036851cf5fc5016665777090dd813cc2de86fc9bd8"
  end

  depends_on "rust" => :build
  depends_on :macos

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
