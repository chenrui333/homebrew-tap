class Sidecar < Formula
  desc "Terminal UI for diffs, file trees, conversation history, and tasks"
  homepage "https://github.com/marcus/sidecar"
  url "https://github.com/marcus/sidecar/archive/refs/tags/v1.11.2.tar.gz"
  sha256 "fd67b175a29bebd8da3f27c56ffbb174a02ed9df11ba4666f4070bcf9b5b609d"
  license "MIT"
  head "https://github.com/marcus/sidecar.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7f621eb7c40106a873ebdd69a91314ee0cd73e1625c01e2b9d0dd0205491b4da"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c96cb2e6f47281b5f03167a061d6435113807b4b3ecb6d972d808c3a7389e209"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e73c663fc28b37af92a71aa8e5167cacb90da27aaec8f2f5d186f2591069625b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3b4e7e4717cfbe20773af5c93ef8b964ff1795dff6042eaf95cf21c269600897"
    sha256 cellar: :any,                 x86_64_linux:  "e2f8f200e804c8cb1a30e0c27a088dd450dcebeda758bafd1196f59fd763b85a"
  end

  depends_on "go" => :build

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
