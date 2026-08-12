class Multica < Formula
  desc "Open-source managed agents platform for AI coding agents"
  homepage "https://github.com/multica-ai/multica"
  url "https://github.com/multica-ai/multica/archive/refs/tags/v0.4.24.tar.gz"
  sha256 "b73b9049c0a0dfd8f62461e3de0d59f61f116b0f76401c0122a32feed67277d5"
  license :cannot_represent
  head "https://github.com/multica-ai/multica.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6595a0ebd2345cadc65af9c307178a9b24e2390ff4212bec07f94506378960b9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6595a0ebd2345cadc65af9c307178a9b24e2390ff4212bec07f94506378960b9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6595a0ebd2345cadc65af9c307178a9b24e2390ff4212bec07f94506378960b9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e6faba281c24b6491ed51efc7bdae5515d0aaa44180275e7d0c018bd64f07768"
    sha256 cellar: :any,                 x86_64_linux:  "eec657f93f180d628af5b3601eb67e27e71d98c71aa048409639beb56e353804"
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
