class Crush < Formula
  desc "Glamorous AI coding agent for your favorite terminal"
  homepage "https://github.com/charmbracelet/crush"
  url "https://github.com/charmbracelet/crush/archive/refs/tags/v0.46.2.tar.gz"
  sha256 "ab8a95ac50801640ea3fd92fc421ae10caf82a8eda7ffc1b38721af5fb481520"
  # license "FSL-1.1-MIT"
  head "https://github.com/charmbracelet/crush.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0bc4a1718f6899bde2a64a12c3ddc21b96089ff2330b97802dcf3f132f48a342"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2dfe64c06ef682e85d5d1d675ce4fc7e10f74306d071da50a775033a6f5a2f06"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3aa3936c597288db16d049e0d0b45d50318d052d5cd255ecce0e2f7823c7e73f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7bd03a4098e3c9d69423358c12dc8b3a22bd84742d0ba2cfaf203e954b8712a8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "33987058fcac9a0873c00b438b6b6f5fa58c3cbe286f80470c034600c8940eb0"
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
