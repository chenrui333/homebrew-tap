class Multica < Formula
  desc "Open-source managed agents platform for AI coding agents"
  homepage "https://github.com/multica-ai/multica"
  url "https://github.com/multica-ai/multica/archive/refs/tags/v0.3.8.tar.gz"
  sha256 "182635dabd4e4b6a3ef698be8b5615931c686f63ab846d5d6807d312e0758653"
  license :cannot_represent
  head "https://github.com/multica-ai/multica.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "eea7af107e8c092026328dc1cf6a07fdec60115278d5ca641599804e194bd98e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "eea7af107e8c092026328dc1cf6a07fdec60115278d5ca641599804e194bd98e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "eea7af107e8c092026328dc1cf6a07fdec60115278d5ca641599804e194bd98e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d20f9ff32882a28e71efc170cb59d2ef97d23a77733ec3b2c4d82446b8e5aab3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "678261ea691c062af68dd437fe08b4ff307eff98e94f3033ecc0933682d5313a"
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
