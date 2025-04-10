class HubTool < Formula
  desc "Docker Hub experimental CLI tool"
  homepage "https://github.com/docker/hub-tool"
  url "https://github.com/docker/hub-tool/archive/refs/tags/v0.4.6.tar.gz"
  sha256 "930f85b42f453628db6a407730eb690f79655e6c1e5c3337293a14b28d27c33a"
  license "Apache-2.0"
  head "https://github.com/docker/hub-tool.git", branch: "main"

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/docker/hub-tool/internal.Version=#{version}
      -X github.com/docker/hub-tool/internal.GitCommit=#{tap.user}
    ]

    system "go", "build", *std_go_args(ldflags:)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/hub-tool version")
    output = shell_output("#{bin}/hub-tool token 2>&1", 1)
    assert_match "You need to be logged in to Docker Hub to use this tool", output
  end
end
