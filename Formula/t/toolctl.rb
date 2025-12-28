class Toolctl < Formula
  desc "Tool to control your tools"
  homepage "https://github.com/toolctl/toolctl"
  url "https://github.com/toolctl/toolctl/archive/refs/tags/v0.4.16.tar.gz"
  sha256 "cc90c2e7fe35f0494d8a20850589377e256628c4dc3de2c268baa9ecd058dbaf"
  license "MIT"
  head "https://github.com/toolctl/toolctl.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "04ae26fba44dfb71bf44a61f40ce65e2b5c765f51ae5e939b22dc7890303a549"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "04ae26fba44dfb71bf44a61f40ce65e2b5c765f51ae5e939b22dc7890303a549"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "04ae26fba44dfb71bf44a61f40ce65e2b5c765f51ae5e939b22dc7890303a549"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "dd7fb01e0056d3362aa6139edd770eee08b3a26617a14e587672ad2407ab77cf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2f7fce69e3699085bbf1f886345aae4adaab9b3c04a82284c8a09e97a9ec57a8"
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
