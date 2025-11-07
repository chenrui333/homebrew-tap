class Crush < Formula
  desc "Glamorous AI coding agent for your favorite terminal"
  homepage "https://github.com/charmbracelet/crush"
  url "https://github.com/charmbracelet/crush/archive/refs/tags/v0.16.0.tar.gz"
  sha256 "e8ad1cc3572ddfe6973423fd78da14561c64b390cc512ba8d1b8970447536151"
  # license "FSL-1.1-MIT"
  head "https://github.com/charmbracelet/crush.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e43f61bf1f313483478456fbfcdaec7aea24576c91f66bf7125e2ec6f51b742c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e43f61bf1f313483478456fbfcdaec7aea24576c91f66bf7125e2ec6f51b742c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e43f61bf1f313483478456fbfcdaec7aea24576c91f66bf7125e2ec6f51b742c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "616d8ee78de88e3a620541055712634e0eb40f0ddc5fa3dea8d0cb55b2ec19a6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ce1e30df5bb6acac551fb1b0d562513db0ee6beec192d814e3c21ad3d53227cf"
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
