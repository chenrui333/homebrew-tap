class Crush < Formula
  desc "Glamorous AI coding agent for your favorite terminal"
  homepage "https://github.com/charmbracelet/crush"
  url "https://github.com/charmbracelet/crush/archive/refs/tags/v0.74.0.tar.gz"
  sha256 "9620dd04ffd8a8f52df31ba953207d9a81a90def5a02e43ecf047f63ac766815"
  # license "FSL-1.1-MIT"
  head "https://github.com/charmbracelet/crush.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b4cb5061ac299669235163688e3d28240f29bca7e03544253fc04789f7986545"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9e2e6e9d33413e31e2b3a8ca926ae736a689350ba7e76b60e0e8dd155615499f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "28810c9951c2d152f255aa902638d3f8d802612a25efb772ef63bc173fcc4f86"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "89a98a344de6e0a2c1fb6470e1a9e09b1252668d3939c85b9f969b32ee77385b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "01c3dcf931d09ad8cd6658be12542e47d0eae21fb1f705c8f19db4ba54119ba2"
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
