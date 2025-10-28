class Crush < Formula
  desc "Glamorous AI coding agent for your favorite terminal"
  homepage "https://github.com/charmbracelet/crush"
  url "https://github.com/charmbracelet/crush/archive/refs/tags/v0.13.2.tar.gz"
  sha256 "32ed7cac0daa03e56a61ef3b2df25d86c4903a0b5b349f8c717e29dd161c5e10"
  # license "FSL-1.1-MIT"
  head "https://github.com/charmbracelet/crush.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "931418eca10bdd71772185c4743b784a9f63416682b0dbce16cd01744509f267"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "931418eca10bdd71772185c4743b784a9f63416682b0dbce16cd01744509f267"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "931418eca10bdd71772185c4743b784a9f63416682b0dbce16cd01744509f267"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7d36cd1ca6d38d7b31e52f1617f783e4851ef7ca92b6b7394c4462fce2b1d44a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e42b91c009b0aab020db3180f7a74b4ed27ba7dafb681db6815f74f2f00f93cd"
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
