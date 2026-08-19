class Sidecar < Formula
  desc "Terminal UI for diffs, file trees, conversation history, and tasks"
  homepage "https://github.com/marcus/sidecar"
  url "https://github.com/marcus/sidecar/archive/refs/tags/v1.1.1.tar.gz"
  sha256 "eaa9d08ca8fe3403becafb6aaa07881dd4c00794a6b84b2e8bb2b4e0674b6261"
  license "MIT"
  head "https://github.com/marcus/sidecar.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "34917bee4affdf77cd7d8c9e0adddd9f23de4392301bcdc1c49e804c78eff837"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "20f3d79e66ff7d9ac5320aca6106099e88efe7f0cc8d0358b6cb59b994682bc6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "442877d04e8f4f3994dc645674de28698991cfb78f134b65876b5ec4c81a6cdd"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5f9f2cf09ab10228b9688d4ea3782e3e1247543736830887e3a0e66f1302bc6c"
    sha256 cellar: :any,                 x86_64_linux:  "0e00994851e4e9df78906eb0515b8fad77c74c0f92f3fb9c5e1225603d7b96ca"
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
