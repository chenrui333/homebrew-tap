class Crush < Formula
  desc "Glamorous AI coding agent for your favorite terminal"
  homepage "https://github.com/charmbracelet/crush"
  url "https://github.com/charmbracelet/crush/archive/refs/tags/v0.47.0.tar.gz"
  sha256 "f9a15ffe26bf35da7b3f8f01d51a5504ba07d04a3862e13330ce9bc439a339b0"
  # license "FSL-1.1-MIT"
  head "https://github.com/charmbracelet/crush.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "140506589a37f96c9d710e0d7d6945282075fcd3a63d2c2381b751d7f8237152"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5c50adbf9a41b875ee1a22811cbc111a54198064c00db58f9e7e9fc3405d0cee"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "baeb9f760eff73b594118426b3f611aff2cc82ed8ded66840fb3d12449d157f2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "266c4762bcdc28f412c721307a6504a94ddee6d81880ff4773eaa4ccc88d211f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bffab8861a9c303fb472686eb463cabad949ba9c12ff1150e663557aa31b561c"
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
