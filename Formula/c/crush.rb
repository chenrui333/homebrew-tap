class Crush < Formula
  desc "Glamorous AI coding agent for your favorite terminal"
  homepage "https://github.com/charmbracelet/crush"
  url "https://github.com/charmbracelet/crush/archive/refs/tags/v0.16.1.tar.gz"
  sha256 "bc28fea67f082b7bb35e5ad05fc44c26d63e2eecf43d5a836ef04b2cd2cbdaa3"
  # license "FSL-1.1-MIT"
  head "https://github.com/charmbracelet/crush.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3338ca5c0095d19f71b1bb0624dca93a4aa40e320a252589c4979261cc492dc3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3338ca5c0095d19f71b1bb0624dca93a4aa40e320a252589c4979261cc492dc3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3338ca5c0095d19f71b1bb0624dca93a4aa40e320a252589c4979261cc492dc3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "634d946e4a715336d939b853643236081c7d2d1a59a86d75db44b1559fdd0a0b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9b586c4a10f2a78a9de317dc19bb7986202427e8fe8fee5d23e3eac20039f114"
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
