class Crush < Formula
  desc "Glamorous AI coding agent for your favorite terminal"
  homepage "https://github.com/charmbracelet/crush"
  url "https://github.com/charmbracelet/crush/archive/refs/tags/v0.99.0.tar.gz"
  sha256 "7faaef06384a10fcc0520b8ab0dbaed8d998795e2df191f8ec85c02f1ef07105"
  # license "FSL-1.1-MIT"
  head "https://github.com/charmbracelet/crush.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "07bdbce7696abff9dd97e087cbe9f483c0eb2c1cd3479d27f1ebd840dfe585c2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4d29136ef2d45f494f75e5d21b48ee2419354f9158a48341e21fb7a25791fbeb"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3b6db0e3d03406bfbbdc0975a0a7c615e36fffa959321ec4eb26a87a78242638"
    sha256 cellar: :any,                 x86_64_linux:  "1c03feec0bda66a71c70f8e3325130a0bfed0aa4218d064af2e9a6fd501d78bd"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

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
