class Toolctl < Formula
  desc "Tool to control your tools"
  homepage "https://github.com/toolctl/toolctl"
  url "https://github.com/toolctl/toolctl/archive/refs/tags/v0.4.15.tar.gz"
  sha256 "4667b156f11e26bd21661b16ae1eab28aed39f88685c8447a23de038b5a63e40"
  license "MIT"
  head "https://github.com/toolctl/toolctl.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1913c577a0baeacde85863b711b08eeb8fd7da363a9b0bd03a57d37bfbedf777"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1f7162acfdb2b28f2107f440cdfc7df9b8dbe75d088ec0cb3267d02f6cc0f83a"
    sha256 cellar: :any_skip_relocation, ventura:       "a26a3e1ee2c5e6254fd1ef0592ee34bf2b5b67b4f7fb61a5c784d5cfc64d962a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "70d8fb08a7d5e1bc118ec1f54d240b56d0102d346a0ebbd2cc9c3572e864950b"
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
