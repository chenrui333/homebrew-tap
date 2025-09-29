class Crush < Formula
  desc "Glamorous AI coding agent for your favorite terminal"
  homepage "https://github.com/charmbracelet/crush"
  url "https://github.com/charmbracelet/crush/archive/refs/tags/v0.10.2.tar.gz"
  sha256 "261805a3810626b06f5693e061a4085691f26fd4b6de43e1904aef9efb6612b7"
  # license "FSL-1.1-MIT"
  head "https://github.com/charmbracelet/crush.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6263e5b717cf57588618681b081dc46ac9781c7147453b538c5d3420abede003"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8188b11f1b4f1a6716b52f9c93a9fa67b0b2b08733c477284ace3d827a5a1a87"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1309de28df32b5051cd4a2af1cc91840a3aaf6d193a0998718be1e3c1a2a4402"
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
