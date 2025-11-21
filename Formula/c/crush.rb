class Crush < Formula
  desc "Glamorous AI coding agent for your favorite terminal"
  homepage "https://github.com/charmbracelet/crush"
  url "https://github.com/charmbracelet/crush/archive/refs/tags/v0.18.5.tar.gz"
  sha256 "d13a87fe91521e4ceace96c98c323e42ba833b53f51c66caad27dd1b78f89e47"
  # license "FSL-1.1-MIT"
  head "https://github.com/charmbracelet/crush.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a1dc24e282bd40df56b14ca637129e19b308eb572154d4480431f72c550c0a2b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a1dc24e282bd40df56b14ca637129e19b308eb572154d4480431f72c550c0a2b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a1dc24e282bd40df56b14ca637129e19b308eb572154d4480431f72c550c0a2b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3898a9408ece657518862972543af5e3a44a81ac7e63f7c6367c98c8c7e5fe51"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "eb6b9fe84122a70f26e9050fe5dcc717c077561d2864f69fc8425c28b063ec9c"
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
