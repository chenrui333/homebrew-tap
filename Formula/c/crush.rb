class Crush < Formula
  desc "Glamorous AI coding agent for your favorite terminal"
  homepage "https://github.com/charmbracelet/crush"
  url "https://github.com/charmbracelet/crush/archive/refs/tags/v0.80.0.tar.gz"
  sha256 "8519390d12e0179ad736dfa8e25163f127e68e0b2667c96827c91090e19ca20e"
  # license "FSL-1.1-MIT"
  head "https://github.com/charmbracelet/crush.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e7cc4351fcdac068df69b90e4a6ff45eb4f8b4c0e6b56ac7dcbd7727d42c3d1c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f5b265cbd61123479c8a2381dcd2d626d9b7b4fb8983371a9054b0ca3a281298"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5c3e019752af8a9d568915305c6253e48846a4533b333fa29aaebaa3d21ce4b0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "aa07213c3d9692e5089bf8d676346dd46a81ac42680cf0d9524ffb3b286fb57c"
    sha256 cellar: :any,                 x86_64_linux:  "2d2ec4850d10a48d535f3d513be8378db0e0562f4985c48a079d6ad826cc05aa"
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
