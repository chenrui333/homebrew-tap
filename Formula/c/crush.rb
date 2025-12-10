class Crush < Formula
  desc "Glamorous AI coding agent for your favorite terminal"
  homepage "https://github.com/charmbracelet/crush"
  url "https://github.com/charmbracelet/crush/archive/refs/tags/v0.22.2.tar.gz"
  sha256 "c79093d449f36a59beab7f1901c4826e56e8a8ed47de1fdc1d9d7bfe0fe54733"
  # license "FSL-1.1-MIT"
  head "https://github.com/charmbracelet/crush.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b1e000cf2858a05d1a20f2490e88a210b65b30c30e7b321cb868b6c43e2af134"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b1e000cf2858a05d1a20f2490e88a210b65b30c30e7b321cb868b6c43e2af134"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b1e000cf2858a05d1a20f2490e88a210b65b30c30e7b321cb868b6c43e2af134"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "45ee4d782cc9b53f1795f78c40878f4c9c27b6fe45b61301fd717d85f671fc56"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d850219f1e3e70f992ebfe84f55233149198bd0bef4164f19e9055d7499d1d62"
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
