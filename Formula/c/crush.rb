class Crush < Formula
  desc "Glamorous AI coding agent for your favorite terminal"
  homepage "https://github.com/charmbracelet/crush"
  url "https://github.com/charmbracelet/crush/archive/refs/tags/v0.76.0.tar.gz"
  sha256 "4a1a7e2a5675ee6f1fb26c2c5d5307d60b6fecd8d5a9989122af0f3589b1d3bb"
  # license "FSL-1.1-MIT"
  head "https://github.com/charmbracelet/crush.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "807da3da8caf56cca156920a79370e44862cef2ee54856689619188ba8c046b7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6f9f1bf2eb5a9c089923051001d12ca014d12e138f7a3ddef161d3a2df69dc96"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8abee6ce5fadc2ead4bf83fbb38cc8346b75f5cea5efade3ba900ceaac807947"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e3aa8f66d40e032c06658b287119b10c5ae8d54b7e86f37b9222d2490ea79698"
    sha256 cellar: :any,                 x86_64_linux:  "e13548fd9213727fe48f383fa69747c518591d63280acd14a3372daf5586d27a"
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
