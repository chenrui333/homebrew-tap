class Ssx < Formula
  desc "Command-line SSH connection manager"
  homepage "https://github.com/vimiix/ssx"
  url "https://github.com/vimiix/ssx/archive/refs/tags/v0.6.1.tar.gz"
  sha256 "ae9d0b0634f06fd23d538c5845042c41c7c624c33e3bc316cf71772ec262b427"
  license "MIT"
  head "https://github.com/vimiix/ssx.git", branch: "main"

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
