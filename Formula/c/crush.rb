class Crush < Formula
  desc "Glamorous AI coding agent for your favorite terminal"
  homepage "https://github.com/charmbracelet/crush"
  url "https://github.com/charmbracelet/crush/archive/refs/tags/v0.30.0.tar.gz"
  sha256 "36488077b582c4a7256b27e86c1d8c176d8a1eb941f51160830a0580d9a19712"
  # license "FSL-1.1-MIT"
  head "https://github.com/charmbracelet/crush.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3fb016e53cc1f8d93db04bb5701d8303272cde11d32d2e511deb3c26e6684bab"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3fb016e53cc1f8d93db04bb5701d8303272cde11d32d2e511deb3c26e6684bab"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3fb016e53cc1f8d93db04bb5701d8303272cde11d32d2e511deb3c26e6684bab"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "bfc693fed410569114999b2aa8e03427e5d3cc9148f3187be8bcac90de67387c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9dd6e1ecf7f5d54c40e074377566521e8693f2212fe60537ac0286a35eb8d293"
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
