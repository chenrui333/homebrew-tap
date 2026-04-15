class Crush < Formula
  desc "Glamorous AI coding agent for your favorite terminal"
  homepage "https://github.com/charmbracelet/crush"
  url "https://github.com/charmbracelet/crush/archive/refs/tags/v0.58.0.tar.gz"
  sha256 "4ee7b092428a5d861cd75019dbb76144c1d3ebd71bad40f6ec62167104f82bc4"
  # license "FSL-1.1-MIT"
  head "https://github.com/charmbracelet/crush.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f632ad628ac3d9b87a887f058a44e69bc6370b4daff2523ef00bacaabc70844b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e76c93d867f81bf7e4dc63c5d07ba7ac98866f979e068957411b00696387ab44"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "cb3689c44f0e54d45e604d9c4ffe9c4d041ec58a21baa2de042a9ac5fbfd04b2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "22d86a5a94e0bf7e96a4048461c89361356dd0a1fa142c7c88b8d40c42877246"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4370837a5a2084eeedbceb92b831eaa10d710cbe000b8acb73ce70161c302b91"
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
