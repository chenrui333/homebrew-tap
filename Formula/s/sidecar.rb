class Sidecar < Formula
  desc "Terminal UI for diffs, file trees, conversation history, and tasks"
  homepage "https://github.com/marcus/sidecar"
  url "https://github.com/marcus/sidecar/archive/refs/tags/v0.92.0.tar.gz"
  sha256 "c465fefe3f522445dfbea63becc8129513b476c40c610aa56b659e4a28d7bd40"
  license "MIT"
  head "https://github.com/marcus/sidecar.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "69640ab1914c48c977664bc43ca2ce993596776b273830a25936ba56b0916e35"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "253fcf0a19199c6dabd30def5a8d0b41f747b61aaa68d5e51ac99cc310f659b3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f4a90432777ea20cf4faf888d77c06d8858507566aeb03fc9a45cf375d2d1973"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7644330d9c2e3ddaf943cb0adc1fe0a2d6e3cc29960c04ae1dbc3d68b51fb9d6"
    sha256 cellar: :any,                 x86_64_linux:  "22b022cfffeba25bb98b60c90cb0445878bb92220eed2975ac37c4068fc5708c"
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
