class Crush < Formula
  desc "Glamorous AI coding agent for your favorite terminal"
  homepage "https://github.com/charmbracelet/crush"
  url "https://github.com/charmbracelet/crush/archive/refs/tags/v0.13.5.tar.gz"
  sha256 "63547dbf2f6a4da220525c6d7456031ee9cd005245e26e0125a3f2fd7c3b74ce"
  # license "FSL-1.1-MIT"
  head "https://github.com/charmbracelet/crush.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "08454a8657c7d0c3c0c8e25a2a79406be9008e2b6613a8279021b1df61d220ec"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "08454a8657c7d0c3c0c8e25a2a79406be9008e2b6613a8279021b1df61d220ec"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "08454a8657c7d0c3c0c8e25a2a79406be9008e2b6613a8279021b1df61d220ec"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "bdc05b21ee8237c40be6860a3e0f74057c7638a3bc226fafa4f84955c45ffb67"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "dd0fadc654a6d88802923e61f249096a4e3786b1f2c038cc63149f8f2ea97ecd"
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
