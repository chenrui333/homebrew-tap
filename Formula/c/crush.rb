class Crush < Formula
  desc "Glamorous AI coding agent for your favorite terminal"
  homepage "https://github.com/charmbracelet/crush"
  url "https://github.com/charmbracelet/crush/archive/refs/tags/v0.8.2.tar.gz"
  sha256 "875be7b34bdbaf980d6e352143f40d88e922f194616b33df447b87e98d83d1d0"
  # license "FSL-1.1-MIT"
  head "https://github.com/charmbracelet/crush.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "470f8f5e165fe5347174fae3ba107d0f3a266f2e6bcf2d6d426d2feea855a183"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "420b4318dfc59ec4f5a30c1b49757b6869434236adf76f2b28781c0f7c0f5edd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "41144e697da1a55ba158bb73e06a1625ee4d701b80967adbd0eeefd9f4cad856"
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
