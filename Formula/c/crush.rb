class Crush < Formula
  desc "Glamorous AI coding agent for your favorite terminal"
  homepage "https://github.com/charmbracelet/crush"
  url "https://github.com/charmbracelet/crush/archive/refs/tags/v0.74.1.tar.gz"
  sha256 "28b75c1761e52065d9960b3c5d5c89e84386ef402b44f582f685d858219b2a2e"
  # license "FSL-1.1-MIT"
  head "https://github.com/charmbracelet/crush.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "167285359b45e976100d2fd02a9b2f4b07ed16bb1a146103172f98d5d5cde086"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "096efa57009be38acfcd0546ba82dca34d27268f17c6233e186f75cffca42c6b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "753ba37ffcde1326a96be2715145381302b1975aa78d0d2faf58905e2c12705f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "36d2fae0cc67e0ba6916eb2944032d65c364a7bcf33895f46a7b0251776157c8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ca991b94dcfe6de45d423db9505c505657a279acc7ae905a576c042464059e2e"
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
