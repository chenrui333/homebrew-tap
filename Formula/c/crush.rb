class Crush < Formula
  desc "Glamorous AI coding agent for your favorite terminal"
  homepage "https://github.com/charmbracelet/crush"
  url "https://github.com/charmbracelet/crush/archive/refs/tags/v0.97.1.tar.gz"
  sha256 "2d008a034c3e7351937e69f4b21ac653e4e0ae2e1fb0fe11b8d37a3094c15d9e"
  # license "FSL-1.1-MIT"
  head "https://github.com/charmbracelet/crush.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4bfeccf02d0cd053d6e5b18b63ca7f1d6f785db3b4523d0e7a290977d94668f7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "12b0b801e23c88b17cf827bdd44238e0d8f8480f0ccb5ef86b5c67053e8e5437"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "65cb3b08e514cc95cf5890afe48d40a2ccf42096c94564d05f14a13dce2505e1"
    sha256 cellar: :any,                 x86_64_linux:  "8a86390099ee877b7774f9df4d98e4f9acb96c1142fcbd5af4928d0ce1a5d158"
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
