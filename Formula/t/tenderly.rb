class Tenderly < Formula
  desc "Debugging, monitoring & tracking smart contract execution"
  homepage "https://tenderly.co/"
  url "https://github.com/Tenderly/tenderly-cli/archive/refs/tags/v1.6.10.tar.gz"
  sha256 "f6fda133553e2d298dfccfb0065480f541ab82fd2546262d894f40808e920cae"
  license "GPL-3.0-only"
  head "https://github.com/Tenderly/tenderly-cli.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "cbf6077a52bccad176013f825345389069d13e9478016b19f37e712ec5f251cd"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "cbf6077a52bccad176013f825345389069d13e9478016b19f37e712ec5f251cd"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "cbf6077a52bccad176013f825345389069d13e9478016b19f37e712ec5f251cd"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2d8bc21fa92512939e6a876897aa95b97ac646b7db4e6b00c18f1cb69a5628d6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "791faf0edf715cd50d3f83152eff5dfdf7e7476025784be569931918066bc493"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.version=#{version}")

    generate_completions_from_executable(bin/"tenderly", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/tenderly version")

    output = shell_output("#{bin}/tenderly init 2>&1", 1)
    assert_match "configuration was not detected", output
  end
end
