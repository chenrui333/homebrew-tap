class Multica < Formula
  desc "Open-source managed agents platform for AI coding agents"
  homepage "https://github.com/multica-ai/multica"
  url "https://github.com/multica-ai/multica/archive/refs/tags/v0.3.5.tar.gz"
  sha256 "80e8d1c6fec082a0639e08a8381822b2bf25598b7d8936f7f0c79850550ecd51"
  license :cannot_represent
  head "https://github.com/multica-ai/multica.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f9f5ca515e23ae6534560f3068d070a2d9ad99b2c8ff158d9cf452bfbe44499d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f9f5ca515e23ae6534560f3068d070a2d9ad99b2c8ff158d9cf452bfbe44499d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f9f5ca515e23ae6534560f3068d070a2d9ad99b2c8ff158d9cf452bfbe44499d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8241b9d07891528d22cc6eba517d2ccc76f060383cf4cd64cffc064bc92ff070"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fe9b83115b0dec7fc8b035d56c2e5e89c3bc7ffe3d7c7f3efa222a7c6e964a67"
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
  end
end
