class Crush < Formula
  desc "Glamorous AI coding agent for your favorite terminal"
  homepage "https://github.com/charmbracelet/crush"
  url "https://github.com/charmbracelet/crush/archive/refs/tags/v0.33.2.tar.gz"
  sha256 "ddd069eb06c2b1e8d8d325d61bdcfb1adee107eadc1f4ee535291979a5b225b6"
  # license "FSL-1.1-MIT"
  head "https://github.com/charmbracelet/crush.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "427f30ceabf3f121c660f63b56d056a98f8ddf0a6f15a536fec377ab24834c4d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8f6353ec8b31dae616523082e42d7680f857194315f8e12abcb626bc620e1674"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7b71930600966ff9c59f142fabe9ec5a357922517600b7b723f35bde2f00383b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c9e7a84c299454b5c33f214743c40d0ace7ab7222b1b08cd8f0e12dcb8f90a0c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fb53d8a20ddf3a32a99b96d06648b81e39e349990b10948f7faef7a280a8f7e3"
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
