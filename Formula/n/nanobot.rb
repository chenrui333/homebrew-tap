class Nanobot < Formula
  desc "Build MCP Agents"
  homepage "https://www.nanobot.ai/"
  url "https://github.com/nanobot-ai/nanobot/archive/refs/tags/v0.0.30.tar.gz"
  sha256 "fe471aa9fd8a45db2ae2b619b9ef4f7bd8ee9a3193f2f52b11808c1374cc71f8"
  license "Apache-2.0"
  head "https://github.com/nanobot-ai/nanobot.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "27a06b22d4f06a0440718e24bab8097487afcf00984ca79423c3324eaa4d74d1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "780686c241b53dd33b8b379067dc056ed97a342e7cf2d887c3bbeb2b283e0bc9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6946624a8b43c070292685ba74a091e96b96adac7be62baa8fec3cfa6c9d31c7"
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
