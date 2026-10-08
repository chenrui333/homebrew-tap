class Sidecar < Formula
  desc "Terminal UI for diffs, file trees, conversation history, and tasks"
  homepage "https://github.com/marcus/sidecar"
  url "https://github.com/marcus/sidecar/archive/refs/tags/v1.17.0.tar.gz"
  sha256 "a8611635e8dc4e94af14368b9ebe28f112886b4a14be776a5a45cc9c550f3865"
  license "MIT"
  head "https://github.com/marcus/sidecar.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3f043b8fc2e0480828d041df2436e0db458545a8c7b08e5c3929beaac65286a3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "008295fa21759e34e8e2d446ea6e8d7852a52976767efa677c1de37cff988bac"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "71c05947b8738794de1a67a5c33f5e3932bfe6bccb97aa39c3f7669df594e7a8"
    sha256 cellar: :any,                 x86_64_linux:  "125fd6e4bef1591a5071bb9c84be3b97684ee304f2313c61e1a5368a32ab5476"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    ldflags = "-s -w -X main.Version=#{version}"

    system "go", "build", *std_go_args(ldflags:, output: bin/"sidecar"), "./cmd/sidecar"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/sidecar --version")
    assert_match "Sidecar requires an interactive terminal",
                 shell_output("#{bin}/sidecar --project #{testpath} 2>&1", 1)
  end
end
