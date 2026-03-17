class Crush < Formula
  desc "Glamorous AI coding agent for your favorite terminal"
  homepage "https://github.com/charmbracelet/crush"
  url "https://github.com/charmbracelet/crush/archive/refs/tags/v0.50.1.tar.gz"
  sha256 "5077fb87831ac6fc74916019bcfc346ca5fe9730d73f4f85aa3728f107a8a47c"
  # license "FSL-1.1-MIT"
  head "https://github.com/charmbracelet/crush.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "fb8ee4250c52b16c340ebdcfd719ead30addb485d9b5926c074c0d792d003c67"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "de3676c3e8c1aa6b1bc69178641101e509b0ab3f0e1228cabcf919cffd926e38"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c50169e8fad453fcb370815cfd8d83d27e11379da4b47052e0c49ebb2b3666e5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "cdcb52d7180058555ece80e275cad4f75d9d0f4581810ea0daeef2fc1c77a4b9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a2a8bd7a49ca79d637f143a43c8de1da40ffa0a12853dfe5c041e3e78f516708"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/charmbracelet/crush/internal/version.Version=#{version}"
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"crush", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/crush --version")

    output = shell_output("#{bin}/crush run 'Explain the use of context in Go' 2>&1", 1)
    assert_match "No providers configured", output
  end
end
