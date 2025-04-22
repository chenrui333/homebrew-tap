class Toolctl < Formula
  desc "Tool to control your tools"
  homepage "https://github.com/toolctl/toolctl"
  url "https://github.com/toolctl/toolctl/archive/refs/tags/v0.4.14.tar.gz"
  sha256 "bd346d2bbff16d25c16f619e7e844f54261e0fc1b9525176b66cce4578a5d821"
  license "MIT"
  head "https://github.com/toolctl/toolctl.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8c71622d913008cec7370a45816a70191a9eb165fb44c4dcbb90a3701de7ab78"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8e4e57a46ac9c7af0c75048f8e2baa527a3bbcc1420e5405241e66818dc6d4f0"
    sha256 cellar: :any_skip_relocation, ventura:       "5d9243400427d5912e7fc56aef09c568dd705f03ce8d021af961ca9d2bb03a25"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "78d56c4a09d71b5797cadcacf3577fb6ecd6ca3b3c7e74a7e11874676ec80875"
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
