class Keyward < Formula
  desc "Manage SSH keys and audit SSH configuration"
  homepage "https://github.com/gateway-of-last-resort/keyward"
  url "https://github.com/gateway-of-last-resort/keyward/archive/refs/tags/v1.0.3.tar.gz"
  sha256 "0b726b18bfe8dc3b8c0d06ce2f833a35c7f35279b2440e70bced5acc7004c8c8"
  license "MIT"
  head "https://github.com/gateway-of-last-resort/keyward.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d9d478e6d007f75ec60986bd241d3cf7f269d1493f96b950b7fd370cc54b8a85"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d9d478e6d007f75ec60986bd241d3cf7f269d1493f96b950b7fd370cc54b8a85"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d9d478e6d007f75ec60986bd241d3cf7f269d1493f96b950b7fd370cc54b8a85"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "11827dc1365b6c38a3ec94abbbd1a64607f4cb1c4d6212f7c79715f7fedcd52c"
    sha256 cellar: :any,                 x86_64_linux:  "63c6cd009f960fc34bdaa9452198d3ef0d33c878f2bbe208904abb414a9ae9d0"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.version=#{version}"), "./cmd/keyward"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/keyward --version")
    (testpath/".ssh").mkpath
    assert_empty JSON.parse(shell_output("#{bin}/keyward list --json"))
  end
end
