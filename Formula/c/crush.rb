class Crush < Formula
  desc "Glamorous AI coding agent for your favorite terminal"
  homepage "https://github.com/charmbracelet/crush"
  url "https://github.com/charmbracelet/crush/archive/refs/tags/v0.13.0.tar.gz"
  sha256 "7aecb5e6108c6f47e9d57540ae2bc78b198f3c11634f1666c4396fa11c6754f5"
  # license "FSL-1.1-MIT"
  head "https://github.com/charmbracelet/crush.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4dae8589038425fb731a75c21e5deefae257b154fd5cef986c86789ad10d0d25"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4dae8589038425fb731a75c21e5deefae257b154fd5cef986c86789ad10d0d25"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4dae8589038425fb731a75c21e5deefae257b154fd5cef986c86789ad10d0d25"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2958cac7219d4b84b72b64f46923b556bc94216fc02d2bf9a6d5012e45cc32cb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e99a250cda622199a467a84f25f53429ed11abde3ed8d3d62544703cb44dee26"
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
