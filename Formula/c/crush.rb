class Crush < Formula
  desc "Glamorous AI coding agent for your favorite terminal"
  homepage "https://github.com/charmbracelet/crush"
  url "https://github.com/charmbracelet/crush/archive/refs/tags/v0.9.2.tar.gz"
  sha256 "9069f807e7af63b44a3a4bc6dd23161f0b08ac23f6c72e9cc52922d59ea7de32"
  # license "FSL-1.1-MIT"
  head "https://github.com/charmbracelet/crush.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3dcdfa91939f5799e229c9b81225f0fa2e31c88338615700bb70db8202735bea"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "49c4ffe2016986656eb77280c4dad22195790a28f6894d2b2e06748f564b59d6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7245c3282eff9915ae3146e3e7365bee298b02092d006c6b16009eb42c86449a"
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
