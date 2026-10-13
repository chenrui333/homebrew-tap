class Multica < Formula
  desc "Open-source managed agents platform for AI coding agents"
  homepage "https://github.com/multica-ai/multica"
  url "https://github.com/multica-ai/multica/archive/refs/tags/v0.6.2.tar.gz"
  sha256 "30ff7e8c4da5a164d59ba57e00d0b041080685cadb1217183888b80405b7482b"
  license :cannot_represent
  head "https://github.com/multica-ai/multica.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e96275ca89a18a1c2126c3d6fd99ec0fc08abf4026c80c62a109f7aaee3a5fa4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e96275ca89a18a1c2126c3d6fd99ec0fc08abf4026c80c62a109f7aaee3a5fa4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3479a0d25ba4c441ec42c25ef13e1dd3e2c32eb3a304da7c2b17a8230dbfa2aa"
    sha256 cellar: :any,                 x86_64_linux:  "457ca123f55ddcaaec8fc3813915a55e9389b8a08d9b1da81bcbff8edad9cb49"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    cd "server" do
      system "go", "mod", "download"
    end
  end

  def install
    cd "server" do
      ldflags = %W[
        -s -w
        -X main.version=#{version}
        -X main.commit=#{tap.user}
        -X main.date=#{time.iso8601}
      ]
      system "go", "build", *std_go_args(ldflags:), "./cmd/multica"
    end
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/multica version")

    system bin/"multica", "config", "set", "server_url", "https://example.com"
    assert_match(%r{^server_url:\s+https://example\.com$}, shell_output("#{bin}/multica config show"))
  end
end
