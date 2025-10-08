class Crush < Formula
  desc "Glamorous AI coding agent for your favorite terminal"
  homepage "https://github.com/charmbracelet/crush"
  url "https://github.com/charmbracelet/crush/archive/refs/tags/v0.10.4.tar.gz"
  sha256 "24074bbf98871966061ca364458d6dfa0c319dcd7910437cc3dcc9911e90113b"
  # license "FSL-1.1-MIT"
  revision 1
  head "https://github.com/charmbracelet/crush.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6a4779a0537996949ad3f6d6b9c4bdf924474cba7c12b6b285048a241b216d47"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b51d9a557bfb493ffde08eceb967e0d0edc1072220524255c465f8c138723fa5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "21d9ca66058a67043b72c2b087e8d7e4db384e318e64430feaaeff5e23d307f0"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/charmbracelet/crush/internal/version.Version=#{version}"
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"crush", "completion", shells: [:bash, :zsh, :fish, :pwsh])
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/crush --version")

    output = shell_output("#{bin}/crush run 'Explain the use of context in Go' 2>&1", 1)
    assert_match "no providers configured", output
  end
end
