class Crush < Formula
  desc "Glamorous AI coding agent for your favorite terminal"
  homepage "https://github.com/charmbracelet/crush"
  url "https://github.com/charmbracelet/crush/archive/refs/tags/v0.70.0.tar.gz"
  sha256 "fc60329c04fd2822f08467336b74a0c73c4284cdd242a3808b11da7193363a39"
  # license "FSL-1.1-MIT"
  head "https://github.com/charmbracelet/crush.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a05840313eb1b0c99959385b67d15ae2677b838dc3aadcfbfa05ba6063d65ecb"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "22fab6a32c73da5c59dfb3befc041d90edac5c7ccb9cf81bdb1436010c1e81a6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "26b88cf0d3089e1f0231a2d8862e075abc6e50b441f5b8c9e264e77a47d0e6ce"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "da6c7de99d5380cc03827707d49905d701307eaac2c9926af5c7e7c5cdbea06c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f3135c0994bd38e3e91dc7833e592cb3cb2978a6264f522d48e58e32114a3ec7"
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
