class Crush < Formula
  desc "Glamorous AI coding agent for your favorite terminal"
  homepage "https://github.com/charmbracelet/crush"
  url "https://github.com/charmbracelet/crush/archive/refs/tags/v0.9.2.tar.gz"
  sha256 "9069f807e7af63b44a3a4bc6dd23161f0b08ac23f6c72e9cc52922d59ea7de32"
  # license "FSL-1.1-MIT"
  head "https://github.com/charmbracelet/crush.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "93d6bbdf72243363245fd97a3abbc49505561bcc84f1923723d4d14d0c20754f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "78b495de599490cdeffa39c476f4f89ec30e6127e01753f30469c4afdeea717b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6c85d8185c530d8f348a472c6ead27f507a70fc667ee7fc74a858046a1eca289"
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
