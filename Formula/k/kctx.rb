class Kctx < Formula
  desc "Kubernetes context engine for humans and AI agents"
  homepage "https://github.com/lucasepe/kctx"
  url "https://github.com/lucasepe/kctx/archive/refs/tags/v0.3.0.tar.gz"
  sha256 "34b9892f3d66514322ece2a0f586f146dc8bbe6a7e58665abb7f9717f928de53"
  license "Apache-2.0"
  head "https://github.com/lucasepe/kctx.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "087b5f8a2e90d969fcc73ffc65b407429491fbfa40f5b55fa21615367e3091a0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "087b5f8a2e90d969fcc73ffc65b407429491fbfa40f5b55fa21615367e3091a0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "281ee6ebd359cdc71768df64314daa2cb35d183ed88190a7d45f40c109958a65"
    sha256 cellar: :any,                 x86_64_linux:  "838442a417305d8ba2bcb5352e425a2dd4b71f84c4e88647b9b8033ecee9875b"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    ldflags = %W[
      -s -w
      -X main.Version=v#{version}
    ]
    system "go", "build", *std_go_args(ldflags:)
  end

  test do
    output = shell_output("#{bin}/kctx 2>&1")
    assert_match version.to_s, output
    assert_match "dump", output
  end
end
