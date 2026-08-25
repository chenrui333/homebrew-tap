class Crush < Formula
  desc "Glamorous AI coding agent for your favorite terminal"
  homepage "https://github.com/charmbracelet/crush"
  url "https://github.com/charmbracelet/crush/archive/refs/tags/v0.91.1.tar.gz"
  sha256 "3709b3a6f60febdc18520fa14985989abc138b192e024ffce66223bd38a93324"
  # license "FSL-1.1-MIT"
  head "https://github.com/charmbracelet/crush.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ba245f29ce41a916055593d311a88fa44892c610469a4775a74e9997ec33ef9a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fb9a2220f9dc10380baee5ef334996ad525aa6e1785b12705a4375445fd9050c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8c2c838d4d9990fbdeaaca259cdf8b03bb96f5fbcd7389bf0a292382e8752b0b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5c4a139900f267f10c8431d5d17658f000420a1441fa9ff676d56f8ab541a2a7"
    sha256 cellar: :any,                 x86_64_linux:  "a2e5895ff5060101d322e8fb4df2b14cff7b43379f5f7fcb1e3b285a14ef0492"
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
