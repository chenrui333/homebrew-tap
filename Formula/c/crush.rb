class Crush < Formula
  desc "Glamorous AI coding agent for your favorite terminal"
  homepage "https://github.com/charmbracelet/crush"
  url "https://github.com/charmbracelet/crush/archive/refs/tags/v0.43.0.tar.gz"
  sha256 "47ad1bb0c8dbb073a2751cb2f83209dc18d52e1b8d5c9dc028ddf06aa9dec19f"
  # license "FSL-1.1-MIT"
  head "https://github.com/charmbracelet/crush.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2616daa6101be5b5e14f5331938f1041d8d553db0d935443cf83583f3bcb7ec6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7e72fc4d5b3ce5ed5071931689addf1cfbda827520f8100466d898ff6521f7d9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f501c3d59d6ebb11b567691a8019a4e8c0914d37ee27a7c3ac0bcdce13ce0723"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "11caf98585a3f649ab4b4d783df78bf412616b38b3f665e1bf99902343e219f1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "eb8c2d74f8c3edaab16af45be468a5d880531878e0722b7378276d9dbf9b7e63"
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
