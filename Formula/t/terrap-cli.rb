class TerrapCli < Formula
  desc "CLI tool that scans your infrastructure and identifies any required changes"
  homepage "https://github.com/sirrend/terrap-cli"
  url "https://github.com/sirrend/terrap-cli/archive/refs/tags/v0.0.4.tar.gz"
  sha256 "4b479cc312207a43ffd92229eb8940074d32b84ec93dc6c53458a13270dc7a21"
  license "Apache-2.0"
  head "https://github.com/sirrend/terrap-cli.git", branch: "main"

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/sirrend/terrap-cli/internal/version.Version=#{version}"
    system "go", "build", *std_go_args(ldflags:, output: bin/"terrap")

    generate_completions_from_executable(bin/"terrap", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/terrap version")

    output = shell_output("#{bin}/terrap scan")
    assert_match "Please execute < terrap init >", output
  end
end
