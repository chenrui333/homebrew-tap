class Crush < Formula
  desc "Glamorous AI coding agent for your favorite terminal"
  homepage "https://github.com/charmbracelet/crush"
  url "https://github.com/charmbracelet/crush/archive/refs/tags/v0.3.0.tar.gz"
  sha256 "7bdaf0eebc5b1d1486745709f1bffc90ba631986769433438e839e241179ff75"
  # license "FSL-1.1-MIT"
  head "https://github.com/charmbracelet/crush.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6109dd05f5616847b6a1eaa2f3c2680752c29bf5645e97a25730247cac6daf01"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0024bd27a02757f822eedfbbd25e13cd9949b0728b88cf6576b7bb53d3a9d0b2"
    sha256 cellar: :any_skip_relocation, ventura:       "4afe20b02e6f0bd40db116f2fcf679c2b77817942205cfc9659c590d24e3b136"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6570ae98cbc1704c38ac7a50a3e5928f8a47e325fe5e07963f6f692b5ec89259"
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
