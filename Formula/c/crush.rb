class Crush < Formula
  desc "Glamorous AI coding agent for your favorite terminal"
  homepage "https://github.com/charmbracelet/crush"
  url "https://github.com/charmbracelet/crush/archive/refs/tags/v0.33.3.tar.gz"
  sha256 "a0206a866ca5ab1bb181573810a93f874d7ba2c70b26ffcb41088f473063bd17"
  # license "FSL-1.1-MIT"
  head "https://github.com/charmbracelet/crush.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4eb7129ae94301638a33abdadbca97d51db4828b9ae8c13ee7b02e94540df852"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fd80565a61c608bf7914d80bcd8974d7baeb7e257c71da00ed652a6168164355"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6b03af0bcd8cda5a49ac6a326f9a001502fce24d59ca91eb6e8c4471feba698d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b2de53d110fadf9045181756edef0a728e063cf3607d6b4f8f008296b90c0104"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "46e559c5a162a9233009c748ec3459555fa73942ece9e86d08d011fc50a07988"
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
