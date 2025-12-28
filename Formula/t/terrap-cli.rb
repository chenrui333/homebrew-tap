# framework: cobra
class TerrapCli < Formula
  desc "CLI tool that scans your infrastructure and identifies any required changes"
  homepage "https://github.com/sirrend/terrap-cli"
  url "https://github.com/sirrend/terrap-cli/archive/refs/tags/v0.0.4.tar.gz"
  sha256 "4b479cc312207a43ffd92229eb8940074d32b84ec93dc6c53458a13270dc7a21"
  license "Apache-2.0"
  head "https://github.com/sirrend/terrap-cli.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "82f14006cf8b2d2a703f8e1f0a3a62379c9dff7dc6d5d601a338098685641cbb"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3b22d0e0353f4ed9e336c607dc0afc2c12cb31fc1f31953a6fe3f58db4b8aace"
    sha256 cellar: :any_skip_relocation, ventura:       "2d9544381fa49fb64c79e5d49e9391dda4b049dbd3b7ca9653e57fbd85ca8442"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0e543f08cddcc2efb753dee35210ca8d39100a9986c5ad51c332fc51a32d4950"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/sirrend/terrap-cli/internal/version.Version=#{version}"
    system "go", "build", *std_go_args(ldflags:, output: bin/"terrap")

    generate_completions_from_executable(bin/"terrap", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/terrap version")

    output = shell_output("#{bin}/terrap scan")
    assert_match "Please execute < terrap init >", output
  end
end
