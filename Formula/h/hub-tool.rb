class HubTool < Formula
  desc "Docker Hub experimental CLI tool"
  homepage "https://github.com/docker/hub-tool"
  url "https://github.com/docker/hub-tool/archive/refs/tags/v04.6.tar.gz"
  sha256 "e033e027c4b6dc360abf530a00b3ac0caec5ab17788c015336eb59a5e854e7d1"
  license "Apache-2.0"
  head "https://github.com/docker/hub-tool.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a66f49bdb38378120894ebd5a485d10962724748735fe7f261f079aeabd803a8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "35490f63e31d82528493159c94f13b0b21841fca74dfafee16b0b90b01ea6452"
    sha256 cellar: :any_skip_relocation, ventura:       "11fa24860ac44280d4f9f0549287cf288a542dfb27d0f909629a11e8e4fcc6ed"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5e1aa944a0edd205ccdcaf17c60e1c388151b323a27a276bdd8a010a2602b824"
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
