class Crush < Formula
  desc "Glamorous AI coding agent for your favorite terminal"
  homepage "https://github.com/charmbracelet/crush"
  url "https://github.com/charmbracelet/crush/archive/refs/tags/v0.92.0.tar.gz"
  sha256 "68a8a878833294fa3fb0dc40aefd925699c061ca78c3f9f097495e6183bd93f8"
  # license "FSL-1.1-MIT"
  head "https://github.com/charmbracelet/crush.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5d8ce3695e6f9000c912a9872d9778d2d8a815fa16f6498a4796f1b16669b5b6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5a709431f593129456a85ae27ec841d68db1dede66e38f6f90538b5cf7b194ca"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c8a005eb30773db8f2d4f2161deb8b0388d810e1a3a375c1487a601b00a6478b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d621623f50a74aa5677ae178f7b370586be6299784436ef53ff38a844bab596e"
    sha256 cellar: :any,                 x86_64_linux:  "fcbc55becd97d0caf33f9d7f0d052d43720cc34bef94a0dd573519a22d0fd36a"
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
