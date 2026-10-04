class Iftree < Formula
  desc "Visualize local network interfaces"
  homepage "https://github.com/t1anz0ng/iftree"
  url "https://github.com/t1anz0ng/iftree/archive/refs/tags/v0.0.10.tar.gz"
  sha256 "89ca2bb7ccb2d3cae4eef7679cb4856ec093aa1dcb3f6952c5d47d740dfbdcbe"
  license "Apache-2.0"
  head "https://github.com/t1anz0ng/iftree.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    rebuild 2
    sha256 cellar: :any, x86_64_linux: "d35a57d53b1a3c8b2802ac9262aa5f086d893dafaeebfbfac6dd75573dbfe548"
  end

  depends_on "go" => :build
  depends_on :linux

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    system "go", "build", *std_go_args(ldflags: :goreleaser), "./cmd/iftree"
  end

  test do
    # FIXME: Upstream does not expose a version command; replace this with a version assertion when available.
    assert_match version.to_s, shell_output("#{bin}/iftree --help")

    output = shell_output("#{bin}/iftree 2>&1", 1)
    assert_match "iftree must be run as root to enter ns", output
  end
end
