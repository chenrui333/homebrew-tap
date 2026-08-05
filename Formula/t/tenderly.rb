class Tenderly < Formula
  desc "Debugging, monitoring & tracking smart contract execution"
  homepage "https://github.com/Tenderly/tenderly-cli"
  url "https://github.com/Tenderly/tenderly-cli/archive/refs/tags/v1.7.1.tar.gz"
  sha256 "202ff6987768010c68380587f1bd665cecd12c5fbdb935718d38c4ed081b5791"
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
