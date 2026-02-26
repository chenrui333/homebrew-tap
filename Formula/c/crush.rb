class Crush < Formula
  desc "Glamorous AI coding agent for your favorite terminal"
  homepage "https://github.com/charmbracelet/crush"
  url "https://github.com/charmbracelet/crush/archive/refs/tags/v0.46.0.tar.gz"
  sha256 "04c43210c5914b8402720174edc1e1dd00943822b7bcc9cde913053f87f40b24"
  # license "FSL-1.1-MIT"
  head "https://github.com/charmbracelet/crush.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5e805488d7b649a125fd8cd2d424ea5760a62eca47a65e7247d615da3c752f03"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9249f0df9837e3e57f3a24e894f6e7f99c6bcc1c12c2cd2d7c3f3366333279ae"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "763c68a312726fa788858ce02d462ff0dc9a9b5d7eed491691ba2890dc31588e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2af1c64b98f50f0f20d7ebb3091d8742039970516be559f52daf53b0430c529c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cd29afa4e53e81d89f89c63606b81312d830d0610879204be19ad65c9aa16020"
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
