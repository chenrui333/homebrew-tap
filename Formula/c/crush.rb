class Crush < Formula
  desc "Glamorous AI coding agent for your favorite terminal"
  homepage "https://github.com/charmbracelet/crush"
  url "https://github.com/charmbracelet/crush/archive/refs/tags/v0.82.0.tar.gz"
  sha256 "6d11a4b015c92e98daa3de022ee6e6e1b7752d5a0f3e1cafb8e383c9002778d3"
  # license "FSL-1.1-MIT"
  head "https://github.com/charmbracelet/crush.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d40f9f418dfff4445c918f245832471a56858a2f4a76a858f0e52ca59a7858d0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3b370b674012a068de79d01420f405373f6fe402d091e037f626787d64d424a4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6a13953c67decd7d8a1a318edc11f19ab16b5d728b11ff5059fa2f168d66cf79"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "02492c27e463af7123320ad047a56c8d5d9f5243e8b770dd4f984298c0e2cfea"
    sha256 cellar: :any,                 x86_64_linux:  "a06031e27dccf2f305d0ef4215b2fff713167156aee830f41a54b56a77442aa1"
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
