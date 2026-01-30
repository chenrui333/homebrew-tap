class Crush < Formula
  desc "Glamorous AI coding agent for your favorite terminal"
  homepage "https://github.com/charmbracelet/crush"
  url "https://github.com/charmbracelet/crush/archive/refs/tags/v0.37.0.tar.gz"
  sha256 "e8456efe7ca7c921f5ec0f643819602915eb43c128b996d983d24784338473f1"
  # license "FSL-1.1-MIT"
  head "https://github.com/charmbracelet/crush.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8bd1a321de6688ec70e2a47d9a61c7087991dd052a1b95975c6b528ddb4bcdd5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2f0c5c301e7a6cb3a9cd90ac8607de97383e391b37b1caf283fd3b738ad4b769"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "dda16e158c7735f4fcb85603bf3d3d7b76903bfa48f8fb9e771c118227d4ad4c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d66dcee7c907924b374e1638c2ab4954c0f1e679278b8bd51b9e97eab9088444"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d98c63cda9863f25110c029ddd499ba0ff556c4ea2a6137bb95699aff8ce6c31"
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
