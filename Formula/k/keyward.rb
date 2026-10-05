class Keyward < Formula
  desc "Manage SSH keys and audit SSH configuration"
  homepage "https://github.com/gateway-of-last-resort/keyward"
  url "https://github.com/gateway-of-last-resort/keyward/archive/refs/tags/v1.0.3.tar.gz"
  sha256 "0b726b18bfe8dc3b8c0d06ce2f833a35c7f35279b2440e70bced5acc7004c8c8"
  license "MIT"
  head "https://github.com/gateway-of-last-resort/keyward.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d86e95cdceef54e2127eb1c3c8f5d08b9c2553bf69e8f4b5b5eec8902261dd95"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d86e95cdceef54e2127eb1c3c8f5d08b9c2553bf69e8f4b5b5eec8902261dd95"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2c91d91ab72910cb540027f78e6075015d56857dedfc4448b0e09f83f96070ca"
    sha256 cellar: :any,                 x86_64_linux:  "8721db4129b31a60fea80aed1fbff26762c4056e28d027c6eeb5f6f3f4018e68"
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
