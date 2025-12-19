class Crush < Formula
  desc "Glamorous AI coding agent for your favorite terminal"
  homepage "https://github.com/charmbracelet/crush"
  url "https://github.com/charmbracelet/crush/archive/refs/tags/v0.29.0.tar.gz"
  sha256 "ebf9a9769dffb5c6f61cc8109a1ae716a12324f61c0a53c0b6ec7adda135db82"
  # license "FSL-1.1-MIT"
  head "https://github.com/charmbracelet/crush.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "78a6e5da4c650f5ba586f83c80906c44b7d656b78bacb1e92f479feac9aed138"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "78a6e5da4c650f5ba586f83c80906c44b7d656b78bacb1e92f479feac9aed138"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "78a6e5da4c650f5ba586f83c80906c44b7d656b78bacb1e92f479feac9aed138"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2c3142273c1f9a271773a17760e62322cb1d35e6f0b285e6b1c5744b913c13fb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6da06f9d9affd5cdeb946d36ad849765cac3c42e4c322580ef12621dcbe3198b"
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
    assert_match "No providers configured", output
  end
end
