class Crush < Formula
  desc "Glamorous AI coding agent for your favorite terminal"
  homepage "https://github.com/charmbracelet/crush"
  url "https://github.com/charmbracelet/crush/archive/refs/tags/v0.19.4.tar.gz"
  sha256 "ef3112bd8fcb151939e5c3a5ffe0237433df1e497ed2bb7e5a172e06caafa83d"
  # license "FSL-1.1-MIT"
  head "https://github.com/charmbracelet/crush.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2cdd9a431ce8c72b9a5fe2d6b1aec53536d182843631f965913e0ba7d6f0c456"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2cdd9a431ce8c72b9a5fe2d6b1aec53536d182843631f965913e0ba7d6f0c456"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2cdd9a431ce8c72b9a5fe2d6b1aec53536d182843631f965913e0ba7d6f0c456"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "402aed89372a4bef58bb7f3abde80e786b4ec3c9dcd0541d4e960920454db043"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d7c7366e17a42934cae71408baafcc3c6684e1c29be1b416c186520726f7af99"
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
    assert_match "No providers configured", output
  end
end
