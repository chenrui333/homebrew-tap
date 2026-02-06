class Tenderly < Formula
  desc "Debugging, monitoring & tracking smart contract execution"
  homepage "https://tenderly.co/"
  url "https://github.com/Tenderly/tenderly-cli/archive/refs/tags/v1.6.7.tar.gz"
  sha256 "07cc5107a1f2aae7819982dac714ec3dd95e6d1b9b0e3a2c419eeeb81dab4985"
  license "GPL-3.0-only"
  head "https://github.com/Tenderly/tenderly-cli.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0b9b196f829d27fa6918343c9abadbc76eda494ee970814bc29018b620b4ea9d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0b9b196f829d27fa6918343c9abadbc76eda494ee970814bc29018b620b4ea9d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0b9b196f829d27fa6918343c9abadbc76eda494ee970814bc29018b620b4ea9d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ba8a74247a6042adcf67cbe995ca25060f1f6b74daae9c0e795735fa90d6bb47"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "45a8bc0ba7bb784cba422cf39853341789d69ed6ff9346fd4ae241a82efbe4c0"
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
