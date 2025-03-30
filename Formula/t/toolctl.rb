class Toolctl < Formula
  desc "Tool to control your tools"
  homepage "https://github.com/toolctl/toolctl"
  url "https://github.com/toolctl/toolctl/archive/refs/tags/v0.4.12.tar.gz"
  sha256 "009a68b33c1b6af51f6b7fbe818354775ca17681f331ec5c8a94662e4e758504"
  license "MIT"
  head "https://github.com/toolctl/toolctl.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c83889932a1740b49b62f624a1abc2285f251f5de6999d537726fbbc40c4b9c6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "39d5d36c1419735b05f4bf08ace4ae32492d20812031127fb5fe00e0dacd5fc7"
    sha256 cellar: :any_skip_relocation, ventura:       "00453b9cc84fdee80dc5f430585591663662adc5e6d92996a359f32a39c7f8e8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4ff5ca5ce52c18b947bc69acd771b4d1f754c812e75d916ae9bdf740459848c8"
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

    generate_completions_from_executable(bin/"toolctl", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/toolctl --version")

    assert_match "toolctl", shell_output("#{bin}/toolctl list")
    output = shell_output("#{bin}/toolctl info 2>&1")
    assert_match "The tool to control your tools", output
  end
end
