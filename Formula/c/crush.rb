class Crush < Formula
  desc "Glamorous AI coding agent for your favorite terminal"
  homepage "https://github.com/charmbracelet/crush"
  url "https://github.com/charmbracelet/crush/archive/refs/tags/v0.43.4.tar.gz"
  sha256 "22ad2171b6d27b92d2b1189607632441194c45dd51caead655114ed2d5a731e0"
  # license "FSL-1.1-MIT"
  head "https://github.com/charmbracelet/crush.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "75c4001ffbc39378c59b9b855986846921e4ee221fbd8bdf43644cb2df31c893"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3174765956ef38c24e07f19e7542b63e9b10671d0a5eb3061f29b8a902a76054"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f31d6a9b8a83b73b9a28ba8e61f9aed37ed41b7e9b56c3a25b80afd445a7625a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9f2149983a79b68966181c9b1d7bdb180951031ee4e6285751f08fc00dc750ca"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e69efb1b689d683ee146e6f7ebb53475cfc52ee89d646a3b8fe185619cfccd0a"
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
