class Nanobot < Formula
  desc "Build MCP Agents"
  homepage "https://www.nanobot.ai/"
  url "https://github.com/nanobot-ai/nanobot/archive/refs/tags/v0.0.29.tar.gz"
  sha256 "57692920aad86430d8bb489c9810731c45bad992aec260d1f09ac0166f952edc"
  license "Apache-2.0"
  head "https://github.com/nanobot-ai/nanobot.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "83030a08953754ecf653dba735cf21e5444b7bb30927ba17331bfc0aeffd7bda"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "15aff55f989b3506bd5e28753f3fcb711b98324201cf970cb4255ef8ab4984c8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6d87369b85b3e163830d12a00eabd328ab5fa945a946a3dafd78897eb168e9b2"
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
