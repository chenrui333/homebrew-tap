class Multica < Formula
  desc "Open-source managed agents platform for AI coding agents"
  homepage "https://github.com/multica-ai/multica"
  url "https://github.com/multica-ai/multica/archive/refs/tags/v0.4.3.tar.gz"
  sha256 "54e4c7ffecdac74aeef1111dc56e5cefc22676af44bbc8dcc1d4961585f491e9"
  license :cannot_represent
  head "https://github.com/multica-ai/multica.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6d42c35985eb7e4eaa88d514134c47ae36e4cbf5385ac78d4ac9b3a1a3f50b01"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6d42c35985eb7e4eaa88d514134c47ae36e4cbf5385ac78d4ac9b3a1a3f50b01"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6d42c35985eb7e4eaa88d514134c47ae36e4cbf5385ac78d4ac9b3a1a3f50b01"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "bf3e607c9bc01bf09fd49d8c805befe6ae1f2ee0f2cf734dc3dd96d6fc1fdc39"
    sha256 cellar: :any,                 x86_64_linux:  "34f62c1204ac5fab03f3e200aba55e4d979db4c3624334d4e92158fc1c5771f9"
  end

  depends_on "go" => :build

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
    assert_match "server_url:   https://example.com", shell_output("#{bin}/multica config show")
  end
end
