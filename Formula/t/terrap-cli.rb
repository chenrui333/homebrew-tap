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
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "592781b1ba501ec1b921cb71bcd5ed5c76593a91e1ee204c90819cec5e116ff8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "592781b1ba501ec1b921cb71bcd5ed5c76593a91e1ee204c90819cec5e116ff8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "592781b1ba501ec1b921cb71bcd5ed5c76593a91e1ee204c90819cec5e116ff8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7f819a72975fb230b080740cce0ac32de6abff2c05867a0e4b928fc7023e2573"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "af731c4e99096d2bc7719901124dabc4c7dc0bf65075daa2133c51a153a8cce2"
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
