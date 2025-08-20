class Crush < Formula
  desc "Glamorous AI coding agent for your favorite terminal"
  homepage "https://github.com/charmbracelet/crush"
  url "https://github.com/charmbracelet/crush/archive/refs/tags/v0.7.0.tar.gz"
  sha256 "2aaba96909ef3f140f2d01f3439852c949dbadc0d9f82f1d22de38dbd79feacd"
  # license "FSL-1.1-MIT"
  head "https://github.com/charmbracelet/crush.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b769b01b0fe62fdcd9bfadf1d9ba2368480487273d3a8efc306c977dba3258de"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e742572cbe3e5c1d4d9a9aa6dee85247bc088f2302eb1d1cbb2c9201f1de1425"
    sha256 cellar: :any_skip_relocation, ventura:       "19dfb3e42913dcf3d1fa8c2e5d70225c8cdbae98b9c7cd627cb7c6631944abec"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "33941cb71db913389ce60c70967789a11eee8757b9997b37c29f026c315ccb0b"
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
