class Crush < Formula
  desc "Glamorous AI coding agent for your favorite terminal"
  homepage "https://github.com/charmbracelet/crush"
  url "https://github.com/charmbracelet/crush/archive/refs/tags/v0.50.1.tar.gz"
  sha256 "5077fb87831ac6fc74916019bcfc346ca5fe9730d73f4f85aa3728f107a8a47c"
  # license "FSL-1.1-MIT"
  head "https://github.com/charmbracelet/crush.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8d12c9b7a4810341a94b15376072a95a6e373b656de58d8465a344d471cacc46"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b2d650bbb2ff74586794d76d518aed0f18e4f80109ceb92738fcbaf4542b1bc8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ea60ec84496be3d0e45641665b50a462a1467dfd0f2f4f682dbb7ab6157b0c67"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "bb58e1e8d675152fec54fc0ffb91566974abd9469db43753e0f1acff1d91556e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8b08ab0a76f58ef14193bdc3b7dc8f3d7f4bcb87be86815597326715bd29232a"
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
