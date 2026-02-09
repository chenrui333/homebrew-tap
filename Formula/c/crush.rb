class Crush < Formula
  desc "Glamorous AI coding agent for your favorite terminal"
  homepage "https://github.com/charmbracelet/crush"
  url "https://github.com/charmbracelet/crush/archive/refs/tags/v0.41.0.tar.gz"
  sha256 "18cebd86bc06d010b3549ef7c6601c8728670c0202db55508871fd3ee82640f1"
  # license "FSL-1.1-MIT"
  head "https://github.com/charmbracelet/crush.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3097fcecd86ec76aaf21fb1769cbeb47edeeaf51e85d86fa571c212b09750941"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4672d658b7cf6b78a4c23b413fb5b8dee9de68e9c10e56e090ee2e3d386caefb"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3f15f181ac9c21a8df8343f1865e14a3b7d028b87a40aa1879a0294f6337d826"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "987f016826673c2b89788d25d07eed01cb874187057df893e0a704bfb8dc0a17"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "49686ecae3a9bdd718c7e1c555ea48cbd561e5b4c105e04702a22c74e372be7a"
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
