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
    rebuild 2
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f0fa663423d347fac2ecb417a3558935fd07e26d17a3edc0052057d81cb1105e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f0fa663423d347fac2ecb417a3558935fd07e26d17a3edc0052057d81cb1105e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e91f5069c55116330ba92b694cbe2cc5f568df59dc7b14ba6906ce64de33f33c"
    sha256 cellar: :any,                 x86_64_linux:  "02b210522b7a3956d87168e0e43c28cb881600870485690538ef1eb2b79dc894"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

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
