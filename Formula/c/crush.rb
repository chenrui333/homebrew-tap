class Crush < Formula
  desc "Glamorous AI coding agent for your favorite terminal"
  homepage "https://github.com/charmbracelet/crush"
  url "https://github.com/charmbracelet/crush/archive/refs/tags/v0.7.7.tar.gz"
  sha256 "0eed78ff73ae9310b22b4fe9525f329c7708200ac2207b5c76e487bb786f9f8a"
  # license "FSL-1.1-MIT"
  head "https://github.com/charmbracelet/crush.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d35924f47540546dc6831b883307df10155be68e6562c2f2c9bbf3875418976d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "faaf0702aa0e8feae5366ad9feba32456351e4925f66af76cf9800d17e51a230"
    sha256 cellar: :any_skip_relocation, ventura:       "059863ed62792635f3519c50de6871a40af481d7aef1968f2ed2fcea5b5dba89"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "304e8b8b418b1e7ac827c90b78372fd8d27d799142222636302690c6847a6ea0"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/charmbracelet/crush/internal/version.Version=#{version}"
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"crush", "completion", shells: [:bash, :zsh, :fish, :pwsh])
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/crush --version")

    output = shell_output("#{bin}/crush run 'Explain the use of context in Go' 2>&1", 1)
    assert_match "no providers configured", output
  end
end
