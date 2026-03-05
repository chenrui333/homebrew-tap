class Crush < Formula
  desc "Glamorous AI coding agent for your favorite terminal"
  homepage "https://github.com/charmbracelet/crush"
  url "https://github.com/charmbracelet/crush/archive/refs/tags/v0.47.1.tar.gz"
  sha256 "d986d0f9975dfb4660bee717c0821165b998afdc95bdcbba7ef8e726df0760fd"
  # license "FSL-1.1-MIT"
  head "https://github.com/charmbracelet/crush.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5751b50ca2ca171d67637fb8b08d1183a004b2cbb4699428007fcd310aa0681a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "abf4e8ebf15c842df261a47f7e8d215e3fb3539aff4d492a7ea4ec6ba6d27769"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "823b240be12946cb217726128b975e8e4e6757538ff07b56820b6ac80637cdfa"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "af2c240f0c2c15eb7c17bf015d83b721d15316bd257cd2218ba1ffea0c14141b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2789d6613003b5820ccbdf264f71e35a9b4d6ae7570c615f1c4081a92ecb4d2f"
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
