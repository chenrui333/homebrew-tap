class Crush < Formula
  desc "Glamorous AI coding agent for your favorite terminal"
  homepage "https://github.com/charmbracelet/crush"
  url "https://github.com/charmbracelet/crush/archive/refs/tags/v0.64.0.tar.gz"
  sha256 "3f12fb1c1c23632f00c31fff2c73acde5d24cca28f1263e6b2393628a2300a59"
  # license "FSL-1.1-MIT"
  head "https://github.com/charmbracelet/crush.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "32830ff8323061cdaa9d7cc44c3e7be37c63c5bce114ecbde883a6a70ebec319"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "88c72be96d86b52c7316269ef5f34383ffec573c13597f7244fb9d1904ab5f47"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a9984e1d023dcd63d4d611202ee48596777f83c116ddd36be5f567fbef8d4b6b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5bb850495ab052cd0abdd9b9bb7d8419d70c5093822ddbafbce79d1f36cee15b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1f7930a78c6d5fdd776da3ddb3eefc68e4536c23d87c4f6e094e6e86188a8eed"
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
