class Crush < Formula
  desc "Glamorous AI coding agent for your favorite terminal"
  homepage "https://github.com/charmbracelet/crush"
  url "https://github.com/charmbracelet/crush/archive/refs/tags/v0.43.1.tar.gz"
  sha256 "3a1b3eafc95c44bd9273d1e00f5e957e8b2968acb2b4e8a803aec5fc26abe939"
  # license "FSL-1.1-MIT"
  head "https://github.com/charmbracelet/crush.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "540e1e99a48bd699b906b6b230ea355bbc1d7583340ef5c78ee8a6d57ac31e42"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "83c69c73f08f661274370fe8bdbb211b9a6408378f241cc6cf4befb315adeeb5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9d3c0c4b655d8bb6d27650226acb36128ed411d4e6f5064426f1ed1f6294ba09"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5f5559f4693c842a951d71692a38f253610de9912fdcbb28ff0be8b9744bcb89"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ed2a0379bf28fb7c1994ec7ccf67db8b2f7c3e7b978b2fdd4f70478886521c0c"
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
