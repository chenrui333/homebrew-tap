class Crush < Formula
  desc "Glamorous AI coding agent for your favorite terminal"
  homepage "https://github.com/charmbracelet/crush"
  url "https://github.com/charmbracelet/crush/archive/refs/tags/v0.32.1.tar.gz"
  sha256 "23ade3280bdc9da1a141e6d715f86d230242730da7132471c195fdd4e37a4f51"
  # license "FSL-1.1-MIT"
  head "https://github.com/charmbracelet/crush.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8aad72857b6288b7a29a8a3d92ba04aaab7594727f5cc2bfd762b23cfd52cf19"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8aad72857b6288b7a29a8a3d92ba04aaab7594727f5cc2bfd762b23cfd52cf19"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8aad72857b6288b7a29a8a3d92ba04aaab7594727f5cc2bfd762b23cfd52cf19"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "251b019ee73ccfd336cc4f034de034a1656abf34c22124ed29b8a810e4b7e1bb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7465bf56e21e912074037d8ecc730e05c2cc0174ff31fc062d8e8b8e4f8aa180"
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
