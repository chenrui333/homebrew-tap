class Crush < Formula
  desc "Glamorous AI coding agent for your favorite terminal"
  homepage "https://github.com/charmbracelet/crush"
  url "https://github.com/charmbracelet/crush/archive/refs/tags/v0.13.6.tar.gz"
  sha256 "03e21307b41fcc9ed79ce4a11519e09e091ae209679f9524dff30fba463a1a6f"
  # license "FSL-1.1-MIT"
  head "https://github.com/charmbracelet/crush.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "69997297fa62198c5c128548d1b34569d129797ba9e631eb11ea8924514a15d3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "69997297fa62198c5c128548d1b34569d129797ba9e631eb11ea8924514a15d3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "69997297fa62198c5c128548d1b34569d129797ba9e631eb11ea8924514a15d3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f86e54ed9cdf573aa195cea8619313bbf23dd7cb9d74e6f5905a3568a7649088"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "46b829aaa3a839bbc77cef45a6d26a2ec774aebe4bc28999d47a4414a50ce823"
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
