class Crush < Formula
  desc "Glamorous AI coding agent for your favorite terminal"
  homepage "https://github.com/charmbracelet/crush"
  url "https://github.com/charmbracelet/crush/archive/refs/tags/v0.27.0.tar.gz"
  sha256 "8d7b6a1f6000e21831a99e7b57c8a1a9ee52ceba0dbd35ceef5490ef8214b623"
  # license "FSL-1.1-MIT"
  head "https://github.com/charmbracelet/crush.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e5b1497f36e1a6809afd1707a046f4234cc500721415fb8890e3533f23a1f651"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e5b1497f36e1a6809afd1707a046f4234cc500721415fb8890e3533f23a1f651"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e5b1497f36e1a6809afd1707a046f4234cc500721415fb8890e3533f23a1f651"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "cbe1480edb5245a281ed19a9b150d668c5a4670b727879cfb95d0cf453d6c714"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5ee04bba218864902e049e2089fcd31dc99f44f5ae9e0811ca1b4470d97468fd"
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
