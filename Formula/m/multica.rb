class Multica < Formula
  desc "Open-source managed agents platform for AI coding agents"
  homepage "https://github.com/multica-ai/multica"
  url "https://github.com/multica-ai/multica/archive/refs/tags/v0.4.0.tar.gz"
  sha256 "bd4c86ab01c56b42c8483d548e6b2484d70fbe9f36de6092c840b81d6cb4664a"
  license :cannot_represent
  head "https://github.com/multica-ai/multica.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "92b1c0ef5e10f1dbdb167f50a4e090f18e2162c3d80cb6a6e566be3254192074"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "92b1c0ef5e10f1dbdb167f50a4e090f18e2162c3d80cb6a6e566be3254192074"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "92b1c0ef5e10f1dbdb167f50a4e090f18e2162c3d80cb6a6e566be3254192074"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9181dd9aa0fd7bcbb710fad41efaef49b6f510665cb7fe57534ba948ad15d1db"
    sha256 cellar: :any,                 x86_64_linux:  "76346962b6e9e762ff16f2a9191f705647be90907d938795385f19711db340f4"
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
