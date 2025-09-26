class Nanobot < Formula
  desc "Build MCP Agents"
  homepage "https://www.nanobot.ai/"
  url "https://github.com/nanobot-ai/nanobot/archive/refs/tags/v0.0.30.tar.gz"
  sha256 "fe471aa9fd8a45db2ae2b619b9ef4f7bd8ee9a3193f2f52b11808c1374cc71f8"
  license "Apache-2.0"
  head "https://github.com/nanobot-ai/nanobot.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a1e3c03f1bda94c6bdc6537a538d1a45482af0ce47b72c614fc6a43b01d31d8c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "de7f827c1ee9a1a82036d41644e2f1e6558282e973235de61a924ad69010ce08"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c2dce558cb8f12f1b735c469f5e67918496a148bc0de64a86276e05c82d230ea"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/nanobot-ai/nanobot/pkg/version.Tag=v#{version}
      -X github.com/nanobot-ai/nanobot/pkg/version.BaseImage=ghcr.io/nanobot-ai/nanobot:v#{version}
    ]
    system "go", "build", *std_go_args(ldflags:)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/nanobot --version")

    pid = spawn bin/"nanobot", "run"
    sleep 1
    assert_path_exists testpath/"nanobot.db"
  ensure
    Process.kill("TERM", pid)
    Process.wait(pid)
  end
end
