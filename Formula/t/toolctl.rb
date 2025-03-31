class Toolctl < Formula
  desc "Tool to control your tools"
  homepage "https://github.com/toolctl/toolctl"
  url "https://github.com/toolctl/toolctl/archive/refs/tags/v0.4.13.tar.gz"
  sha256 "3419689983e0c42551e1a3eab09c479c7ff76a627feea6b9e3022b58c0be0b04"
  license "MIT"
  head "https://github.com/toolctl/toolctl.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5eaae6ef379412aec9cc0818be17db26fa8f8078fa0d6174c0c338821ef76401"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ba04378e960639cca28b11e1991e3f10471d3164e7798e0f8d5aee9555319c1b"
    sha256 cellar: :any_skip_relocation, ventura:       "46b324b6a34b765f8eb6305218cb0291e7cb464977707e28468acf45459ae3f9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "593b633e9991ee0cacb7f369e09833a1a38645a9ab4185f0c98d34279d85407d"
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
