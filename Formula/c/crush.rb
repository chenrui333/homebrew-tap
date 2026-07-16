class Crush < Formula
  desc "Glamorous AI coding agent for your favorite terminal"
  homepage "https://github.com/charmbracelet/crush"
  url "https://github.com/charmbracelet/crush/archive/refs/tags/v0.85.0.tar.gz"
  sha256 "6ecd046e546304724c60f9704f950bbcaf4cff2ac58bc03521fb5a5346573ebb"
  # license "FSL-1.1-MIT"
  head "https://github.com/charmbracelet/crush.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f73d317d4dc225225a8c6981ce16e78011549b52542bdfae0de24eb3af028350"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2285937df898454dcd9eafa3446f6325a96700982ca2cc5e3542cec5767b709f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b98f6a0152daa9e2aeff9258a13760a6d804b5d1d145726a21e8b5a3a485563f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "964e92378a6abc357c9ddb02f647cfeb73cddee9760c82fc108bd60ecab26189"
    sha256 cellar: :any,                 x86_64_linux:  "213e6ed379718d33f94692eae218e29cc2e9376ad21e17069a1dc2c974c24cf0"
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
