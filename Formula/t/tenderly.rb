class Tenderly < Formula
  desc "Debugging, monitoring & tracking smart contract execution"
  homepage "https://tenderly.co/"
  url "https://github.com/Tenderly/tenderly-cli/archive/refs/tags/v1.6.6.tar.gz"
  sha256 "f3a91adf489b50b61b1c13d664be77c6d4130fa2a8f554fe091700ead9978d8b"
  license "GPL-3.0-only"
  head "https://github.com/Tenderly/tenderly-cli.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3e5637665ecc3a89321ac4a64523083cb0e10454c356927776f3e33de2f18aac"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a26f048b40558467ea26e81bf14581fadce5c326659c6da08c9a59c6fc9d30b2"
    sha256 cellar: :any_skip_relocation, ventura:       "f9440727b22cb3669055fb4e2de936a29120c8b862b6fd25269458a0b5909d87"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cb3e05db9fe60635e1c0d3e233e8de1120aedd5ef3df28a9d91eec5b0bc7af5b"
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
