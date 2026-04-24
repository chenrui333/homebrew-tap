class Crush < Formula
  desc "Glamorous AI coding agent for your favorite terminal"
  homepage "https://github.com/charmbracelet/crush"
  url "https://github.com/charmbracelet/crush/archive/refs/tags/v0.62.1.tar.gz"
  sha256 "fc147b9c26f792f1b2b9334943c7abdb0b5f56cf98d2a391e57531d221d4e79e"
  # license "FSL-1.1-MIT"
  head "https://github.com/charmbracelet/crush.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "03c80120b379f733c2b38a41f22571b697e9a9c7ec032b605ca3e8956e454cee"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4c855c8d142204f979ab7e481dc5431ad0d840f88c3652bf4861cb8379701abd"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "97d33337ca01d7541ab93f2ea4d39a374e700dde759299213947e8e5e009d4da"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f37d09bceeaa2beb406d5afbc2ccb82681b205ce29dcf803e893427658441a99"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4b2736df4c838d7b70ccc25e9940d5b9b43f2650e998161238b1e1047eb3b245"
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
