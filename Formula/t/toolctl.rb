class Toolctl < Formula
  desc "Tool to control your tools"
  homepage "https://github.com/toolctl/toolctl"
  url "https://github.com/toolctl/toolctl/archive/refs/tags/v0.4.17.tar.gz"
  sha256 "6b2e2f208f34ceeb0c9c88edda45d372f41886dfe00133880ed5626064676778"
  license "MIT"
  head "https://github.com/toolctl/toolctl.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d88b5f3962506e6324dc6b383061be7a37708e4518179101a0026d29b11b6ba3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d88b5f3962506e6324dc6b383061be7a37708e4518179101a0026d29b11b6ba3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d88b5f3962506e6324dc6b383061be7a37708e4518179101a0026d29b11b6ba3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "12e0f588f7f9011dc11857ca1ae2037fd64e4f10d244952dd5336844bdf8ccdb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4056818afd28b562d1cf91f50c36df6b4a81b30766cea4b6334e6ac52e105c83"
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
