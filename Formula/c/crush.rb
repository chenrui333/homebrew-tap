class Crush < Formula
  desc "Glamorous AI coding agent for your favorite terminal"
  homepage "https://github.com/charmbracelet/crush"
  url "https://github.com/charmbracelet/crush/archive/refs/tags/v0.69.1.tar.gz"
  sha256 "d615d5a087f7696cc2a18b3e2b618e6bfce300443fe7eee8dd2636a15d66b2e1"
  # license "FSL-1.1-MIT"
  head "https://github.com/charmbracelet/crush.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "425075586896b13aa98de33a92623045e181eebe78c6a5ad78565937ade519c0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "83eb76fd84d7bff9d97ce0be3a40d523555b1dadeaaec2c9b787100d741727c2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "10e79d04dd0388071596698dbde7e52a43b4e46140037e671a9e91ea4f220c5b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1cc2875abeadd427817af757d40d80b2ca42d42b4ca3c9f4edc65e82eecf218f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fde12b99733740122ce5c47f98f163eb7e4407619f278913253e59a41a1f9061"
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
