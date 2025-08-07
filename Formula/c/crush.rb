class Crush < Formula
  desc "Glamorous AI coding agent for your favorite terminal"
  homepage "https://github.com/charmbracelet/crush"
  url "https://github.com/charmbracelet/crush/archive/refs/tags/v0.3.0.tar.gz"
  sha256 "7bdaf0eebc5b1d1486745709f1bffc90ba631986769433438e839e241179ff75"
  # license "FSL-1.1-MIT"
  head "https://github.com/charmbracelet/crush.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a3b7ec2533d38d4c93d6e8460a0dd8960ca62b69b407a3b8092de1abd37776d7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "766121eb148e26e462f4b8d84e8397f672064bfa90285763167be78d13178c9d"
    sha256 cellar: :any_skip_relocation, ventura:       "32b1e226b06ff0024620d8b765d0018a4b9d7c32c6975caee1ed45cdb0b02ec8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "db4d888171b90a4e3af48cc8b9ecd859c8d5022dc020ff6dac890b994ac43656"
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
