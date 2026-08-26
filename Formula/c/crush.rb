class Crush < Formula
  desc "Glamorous AI coding agent for your favorite terminal"
  homepage "https://github.com/charmbracelet/crush"
  url "https://github.com/charmbracelet/crush/archive/refs/tags/v0.91.2.tar.gz"
  sha256 "fe6a73a6e512441fa3d6dfaf5473cb3348a71965e904cb47245faeccb74520e0"
  # license "FSL-1.1-MIT"
  head "https://github.com/charmbracelet/crush.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "99422028206adc9e151a5dbfc47a6bfee98bf87db2c7c9e482aec4fb476c5e5b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "08f5e8a032aa65dd44e9ade36672a295175140070bc2f05ed7362283c239259e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0c257882a418540fa0a67dedcdfc7e02b4703a3cb1c4187986db7b431dbd5120"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0d48e1555b9ae908b88e655269ba752f60d3f76e34bf4b75b89b99f8f936ece0"
    sha256 cellar: :any,                 x86_64_linux:  "0c8c540a4080b01defdbb4f25b79631d4815412d2483bc2a3df0da0939cf7321"
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
