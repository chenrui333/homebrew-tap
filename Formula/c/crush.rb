class Crush < Formula
  desc "Glamorous AI coding agent for your favorite terminal"
  homepage "https://github.com/charmbracelet/crush"
  url "https://github.com/charmbracelet/crush/archive/refs/tags/v0.65.2.tar.gz"
  sha256 "81b5edb30aa824ecdba92febe024f08e37dbe9634164dec2f1203f16f1cc968a"
  # license "FSL-1.1-MIT"
  head "https://github.com/charmbracelet/crush.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8f46e1272a696f8b38f07acd8c2f76eae22fdf723743522dc92d1dd5758234f5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "59eea7d898b9c5539bf9ec3b70c12f687d28eba06ff1ac91b7173d35710c01b5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "862a881cc410f6709c1615e0b194b3f6d81170bf7e3abc440a65ed46cf94533e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c8c8f9486fcb662bea8316350e14a0e5d9d18a5f509401f88f09c246a79be3fc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "40581295508cf517c3160cafac8d1109a182b45e31e78feaaee1c6d85e75df76"
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
