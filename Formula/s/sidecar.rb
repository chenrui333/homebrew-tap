class Sidecar < Formula
  desc "Terminal UI for diffs, file trees, conversation history, and tasks"
  homepage "https://github.com/marcus/sidecar"
  url "https://github.com/marcus/sidecar/archive/refs/tags/v0.83.0.tar.gz"
  sha256 "4acc024d7d23d41d19467f6a50fba9bb18435138bb2e90f9928b0f427e88a3f6"
  license "MIT"
  head "https://github.com/marcus/sidecar.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d688d44e82c254a27d59fa1593a202cf7d756b78e7edac2ddcc8130189b8f7d5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "cfeab4afa05f68538cbef41f2041838bacf2bff16bf1618b0dcb6d08265f578c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a6767fad627c9221bc08ee1754f341ef2d05e4e2fa9d96714aa24be717241b39"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ae829dbddc402e98e59dbf56dd5708bc28474309b9f4bc063213dcc73b2e61fb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2a86dc27ba47bf94ee21be45b7e19cafdb9047a992fd43ddb265faa1423555e0"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.Version=#{version}"

    system "go", "build", *std_go_args(ldflags:, output: bin/"sidecar"), "./cmd/sidecar"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/sidecar --version")
    assert_match "sidecar requires an interactive terminal",
                 shell_output("#{bin}/sidecar --project #{testpath} 2>&1", 1)
  end
end
