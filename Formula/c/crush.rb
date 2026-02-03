class Crush < Formula
  desc "Glamorous AI coding agent for your favorite terminal"
  homepage "https://github.com/charmbracelet/crush"
  url "https://github.com/charmbracelet/crush/archive/refs/tags/v0.39.0.tar.gz"
  sha256 "9dbe7661db14ff94dfd154a5a08ab3797f5ec94f0ab4cc71efd13c320efd7c5f"
  # license "FSL-1.1-MIT"
  head "https://github.com/charmbracelet/crush.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4324ee0072ac88cb1534f4ffee7b19014c8ff0fcbbacb5322853ea708816ec15"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1c863b3359d4550d63d1ea6655898b9e293911f515dbbec30af96afe15e1a6e2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "cf74274130cd607581e48f176680ceacae6c86674e61fb58f1e5ab21f5e2a950"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5ae00c657e42529d2d704ba33dd22e5065c7716bda68428e82d276f6cb53733b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "648745501deabf2a6db4f190591a82d5880b1a0d1933b12553483f72b2ed183d"
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
