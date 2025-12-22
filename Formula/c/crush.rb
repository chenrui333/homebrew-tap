class Crush < Formula
  desc "Glamorous AI coding agent for your favorite terminal"
  homepage "https://github.com/charmbracelet/crush"
  url "https://github.com/charmbracelet/crush/archive/refs/tags/v0.29.1.tar.gz"
  sha256 "4708663cac163b59fd89928f21a40cfebeb59149531fa4ccece594a26fa138c1"
  # license "FSL-1.1-MIT"
  head "https://github.com/charmbracelet/crush.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6ac5c96f178b42d0295ffbb4c83770559baa2eac295c3838229a2e0e2fbd3b8b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6ac5c96f178b42d0295ffbb4c83770559baa2eac295c3838229a2e0e2fbd3b8b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6ac5c96f178b42d0295ffbb4c83770559baa2eac295c3838229a2e0e2fbd3b8b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7478b4e8517eb7bfea46adb8b2570254a4dfd393f6d552d457d201cb68a69ce4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "db8f81441c1c735afb22ca1aa6c8f8bd552b0af0c49bcc329871ed2fa2456f61"
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
