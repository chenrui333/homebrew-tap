class Crush < Formula
  desc "Glamorous AI coding agent for your favorite terminal"
  homepage "https://github.com/charmbracelet/crush"
  url "https://github.com/charmbracelet/crush/archive/refs/tags/v0.60.0.tar.gz"
  sha256 "6c2d912172d4483813d2cc72c5610fa2c080ce4447829ec6a86c5148604fe3a8"
  # license "FSL-1.1-MIT"
  head "https://github.com/charmbracelet/crush.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6105b7098af499897c97d62c846c3d1bfe02efa7ec7f5ac590cad96ba5961d9c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "32dd6d357b78c0adec068ef5315491fa34415a397e056ff85fe03b752e63ece2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6a5f11f696d4945458f279d52beacc830b5364cef4af30ad47a98ba2db38cd49"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8085a373ee3d155b3ab19692f3006c1965b831bcc26e01815ed351845d156ace"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "99ab0d47fc417d94af6e55f1411f0e70f0b5ef69a8746ee327b1f6c16fda7aa5"
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
