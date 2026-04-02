class Crush < Formula
  desc "Glamorous AI coding agent for your favorite terminal"
  homepage "https://github.com/charmbracelet/crush"
  url "https://github.com/charmbracelet/crush/archive/refs/tags/v0.55.0.tar.gz"
  sha256 "cbf7a3661090cda958b96c087f8a4be2a74f24fa78796fce1b265287cd74e6cc"
  # license "FSL-1.1-MIT"
  head "https://github.com/charmbracelet/crush.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4ff1fb1c47eaab44e7048c5b6a7e1cea82f6f0de78ff30888b2be1bd98504a1c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e6b0b7ffee60f1599e48e9daf91d1795149199bdb172906d4d39135372fb27ff"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2d028cdf10140380c7fb6d6be3ec049682bc2800aa20b54ed0fe6f198445ad66"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f16739120c703c6a747f60523c634c02ade08d941598870f0b92107b2859c100"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "688653d0512903b845d614e4cfb57cfb14b58faa3b48294d1115848f7f078e76"
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
