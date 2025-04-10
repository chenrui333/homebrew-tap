class HubTool < Formula
  desc "Docker Hub experimental CLI tool"
  homepage "https://github.com/docker/hub-tool"
  url "https://github.com/docker/hub-tool/archive/refs/tags/v04.6.tar.gz"
  sha256 "e033e027c4b6dc360abf530a00b3ac0caec5ab17788c015336eb59a5e854e7d1"
  license "Apache-2.0"
  head "https://github.com/docker/hub-tool.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3f5748cd452a47a9fcdb29bad772cd294adb0e3aacd2733cca2312e31f4a28ff"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c767ff476f2504ba59899e031089f5ec4c2ef40eddd8089c034f8b7a2c5373ca"
    sha256 cellar: :any_skip_relocation, ventura:       "60ef491bde1364768f2e305b8c6c8270944bd419da756dc9d4040d1d4bdc756f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "59b9c58e382f2c212e25918b6041e36348a9d97ad3a42cc41ff9e065be2f994b"
  end

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
