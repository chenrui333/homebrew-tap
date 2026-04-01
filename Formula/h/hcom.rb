class Hcom < Formula
  desc "Let AI agents message, watch, and spawn each other across terminals"
  homepage "https://github.com/aannoo/hcom"
  url "https://github.com/aannoo/hcom/archive/refs/tags/v0.7.7.tar.gz"
  sha256 "7d7c149fc614f00e7b906f7d5844e77d90721e97c909fcd010448f448ce31ba1"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9db908490c03dd9de9dccbfc865e1484f5ecfdcd70ec8edae47bd71e60d8efa9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "be565a1f045330a8d608784b955ad0421e6e6f7f2d975106b5380f3c7430f1fd"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a2e460f8fdd5dd87be25fd40063e58cc0982d9ae3fe094af8eff7000ef78acc3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "80766983489d7855c19d07f27ea8f2d02be3c9d88441b0b40bb3f0ba74319fc8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3c7bade51f34030a402bf835c3cbf74a1c2b0cbbffc4408e04590d8dac7d9b18"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/hcom --version")
  end
end
