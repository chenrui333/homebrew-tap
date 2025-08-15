class Crush < Formula
  desc "Glamorous AI coding agent for your favorite terminal"
  homepage "https://github.com/charmbracelet/crush"
  url "https://github.com/charmbracelet/crush/archive/refs/tags/v0.6.2.tar.gz"
  sha256 "a84fa00092bf9253539713e3c50451faa44240b8aa151e846dcb1aab87f1bcd3"
  # license "FSL-1.1-MIT"
  head "https://github.com/charmbracelet/crush.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a97b227711d2d3de036d96ed1d8a5081ec5ee94cb24707eda4e78ff75604b015"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e7856bb98a1605064167623d7d4420b5930c16fc773c6ee75f4a8b0b2b70c90d"
    sha256 cellar: :any_skip_relocation, ventura:       "f6f184989f48254420ba01c8b237d6c36ecf0d4bd5e742716cf22e4b5a89dfb0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "80d813ba9cc45f75aa77b280a5c548810a12f3a85a7b7ef7d94a49c834184296"
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
