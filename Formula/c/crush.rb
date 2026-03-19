class Crush < Formula
  desc "Glamorous AI coding agent for your favorite terminal"
  homepage "https://github.com/charmbracelet/crush"
  url "https://github.com/charmbracelet/crush/archive/refs/tags/v0.51.1.tar.gz"
  sha256 "0aeb405d820881a936f878b4c1a88f0782a7157c5df4ed04523e4061e73d1e24"
  # license "FSL-1.1-MIT"
  head "https://github.com/charmbracelet/crush.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "16a96099b1b9d1ddfeb2861f7f98cd6f9d05bd30fc4c6e46d7e5911f94c3fe36"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "800e5611c3a18556f805233f27113b5fe1752ced80b9bb8eaff23e440a263347"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "73bc8a6c4d437d38d55911baa486fe01d9382022f448a4ddf48208f2566e2bc5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3ff9d979e28a0dc0250f757a877b3fe905a5b987a2787899f3c4165b80fea518"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5d5d2305ea3d2c04563749503478b503454efaa4ea29e3aece691959d72e2c2e"
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
