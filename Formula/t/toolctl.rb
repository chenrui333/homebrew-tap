class Toolctl < Formula
  desc "Tool to control your tools"
  homepage "https://github.com/toolctl/toolctl"
  url "https://github.com/toolctl/toolctl/archive/refs/tags/v0.4.16.tar.gz"
  sha256 "cc90c2e7fe35f0494d8a20850589377e256628c4dc3de2c268baa9ecd058dbaf"
  license "MIT"
  head "https://github.com/toolctl/toolctl.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "71fcd7cb005cc5482e6c593a643ca75706347c2b3545356e73bc07c40cf9f4ee"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "71fcd7cb005cc5482e6c593a643ca75706347c2b3545356e73bc07c40cf9f4ee"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "71fcd7cb005cc5482e6c593a643ca75706347c2b3545356e73bc07c40cf9f4ee"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7ed87a1e25cfc32f51ac02e914787388130408dc815fccc78cf2c009f33c05e7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d3f2c23d29623e2f353ffd9c6a7775abade122f99b62924d95e9663b760d32b3"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/toolctl/toolctl/internal/cmd.gitVersion=#{version}
      -X github.com/toolctl/toolctl/internal/cmd.gitCommit=#{tap.user}
      -X github.com/toolctl/toolctl/internal/cmd.buildDate=#{time.iso8601}
    ]
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"toolctl", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/toolctl --version")

    assert_match "toolctl", shell_output("#{bin}/toolctl list")
    output = shell_output("#{bin}/toolctl info 2>&1")
    assert_match "The tool to control your tools", output
  end
end
