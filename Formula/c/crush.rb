class Crush < Formula
  desc "Glamorous AI coding agent for your favorite terminal"
  homepage "https://github.com/charmbracelet/crush"
  url "https://github.com/charmbracelet/crush/archive/refs/tags/v0.10.3.tar.gz"
  sha256 "8ee3b96cf8f73674c362ebe11c139de1dc14d0c94d0b1a12d5096821d82a5b53"
  # license "FSL-1.1-MIT"
  head "https://github.com/charmbracelet/crush.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "529c577bb6ccf04c5728debd19a46ef9c05915ab08971e6d7cd9cdd8ff5067a8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8dcf824422659eb066539731e8582fc20921b5e047690d8921f6320aa5495222"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7a9cc902fa0f224ba501348b8024ac71d4bb87238df15dc028d233cace515187"
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
