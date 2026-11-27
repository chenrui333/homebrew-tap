class Ssx < Formula
  desc "Command-line SSH connection manager"
  homepage "https://github.com/vimiix/ssx"
  url "https://github.com/vimiix/ssx/archive/refs/tags/v0.6.1.tar.gz"
  sha256 "ae9d0b0634f06fd23d538c5845042c41c7c624c33e3bc316cf71772ec262b427"
  license "MIT"
  head "https://github.com/vimiix/ssx.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    manifest_sha256 "8cd48f8b8430e1f5c8fdf1305a678e1951f2bbe087d71f87d5509c95a85c308e"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "146485be60713b846eb11e51667fa4299dff5270c6fa2638604969650376b799"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "146485be60713b846eb11e51667fa4299dff5270c6fa2638604969650376b799"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8c9f23d2b452c4a86745e5b740ba4690c90626f539cf30e924fc71d379300e54"
    sha256 cellar: :any,                 x86_64_linux:  "1deb29bf19417f3a013729d49b97def104d5745f19cf5962b69245ce9483d4eb"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    ldflags = "-X github.com/vimiix/ssx/ssx/version.Version=v#{version}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/ssx"
  end

  test do
    assert_match "v#{version}", shell_output("#{bin}/ssx --version")

    output = shell_output("#{bin}/ssx cp 2>&1", 1)
    assert_match "accepts 2 arg(s), received 0", output
    refute_match "panic:", output
  end
end
