class Hcom < Formula
  desc "Let AI agents message, watch, and spawn each other across terminals"
  homepage "https://github.com/aannoo/hcom"
  url "https://github.com/aannoo/hcom/archive/refs/tags/v0.7.14.tar.gz"
  sha256 "2ec4003bfbb9fc5c42bdaeaa57d7f265c4c74b7f1d177dd8bbd4cf3c74683f17"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2abc6acecd80f5490cb4d2947c3a6e09203e5f5f882ee6fa6f967d34d0db524f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1a0e7573b4d3c092d9604d37c27c971832687807a06a00bced47a5204efda896"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e867a4b882623d694085f6e1bd590f0d25e197c107464c5c9be1a87ab749ef5c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a294b1683b801023e2f48f961899495043e9a3e54e6ba1227de0da3ffdf0b0f4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5859819efa80c287d621d7161f5c59f3ff33e61917aad072d3f63de0637ec7a1"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/hcom --version")
  end
end
