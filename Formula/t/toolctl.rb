class Toolctl < Formula
  desc "Tool to control your tools"
  homepage "https://github.com/toolctl/toolctl"
  url "https://github.com/toolctl/toolctl/archive/refs/tags/v0.4.11.tar.gz"
  sha256 "6b07e94e661790d6ef78b83c3617d4579b6d648544a5320b033169f272b73b6f"
  license "MIT"
  head "https://github.com/toolctl/toolctl.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ef3b87da6e13be94a5b94733428fa26fa4122063441c6cc59fe9483f26dfd490"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2965baf23070f7c4cface4480773018bccddca4d57b49fe3489ffe6be6f9cfb9"
    sha256 cellar: :any_skip_relocation, ventura:       "5bfc2d78c4c1b517e8b71b10ffdb613ccf0f623b1d93e5d0c3b02e933d9e07a4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ee6ec9aa8247061363b68b8d0b7583cc35da3ff0f1c3c9433cafc81e579c731c"
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
