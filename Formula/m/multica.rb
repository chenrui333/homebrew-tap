class Multica < Formula
  desc "Open-source managed agents platform for AI coding agents"
  homepage "https://github.com/multica-ai/multica"
  url "https://github.com/multica-ai/multica/archive/refs/tags/v0.4.27.tar.gz"
  sha256 "a7c62bd231e4702be7f14322800e5e883afc08870dd702552b2efdfc663543cd"
  license :cannot_represent
  head "https://github.com/multica-ai/multica.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f4347fa91261931f3c17bf2898224ce3f427c380e0a2419d9d06ac0bc249cae1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f4347fa91261931f3c17bf2898224ce3f427c380e0a2419d9d06ac0bc249cae1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f4347fa91261931f3c17bf2898224ce3f427c380e0a2419d9d06ac0bc249cae1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e88041812ce78a1296f157d03fb7ad9626f347852da8d55881809fb9cb024ccf"
    sha256 cellar: :any,                 x86_64_linux:  "c4dce04c62c13078a8ee2e4b4deb3d81ae47a8d7a1666ec7be24b3e932dcc906"
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
