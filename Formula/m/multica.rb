class Multica < Formula
  desc "Open-source managed agents platform for AI coding agents"
  homepage "https://github.com/multica-ai/multica"
  url "https://github.com/multica-ai/multica/archive/refs/tags/v0.4.31.tar.gz"
  sha256 "661d56c822f4018d3d53f0018a522a79fe1e33a0c4ed2242248a55e67f940806"
  license :cannot_represent
  head "https://github.com/multica-ai/multica.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e2fa8c45bef715e0b1b7ee88ae7c6a1b1883d657d2d5fd4b84a22e623cccc956"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e2fa8c45bef715e0b1b7ee88ae7c6a1b1883d657d2d5fd4b84a22e623cccc956"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e2fa8c45bef715e0b1b7ee88ae7c6a1b1883d657d2d5fd4b84a22e623cccc956"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ac1c4f6bf576ec1752b7809cd06ae54676b8367636e724f267ccdf71ffccbb1a"
    sha256 cellar: :any,                 x86_64_linux:  "a62e30cf472c8d24fc9faf4f421aeb02eda398c6cdb7c1a018b441d3c0ee23f1"
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
    assert_match(%r{^server_url:\s+https://example\.com$}, shell_output("#{bin}/multica config show"))
  end
end
