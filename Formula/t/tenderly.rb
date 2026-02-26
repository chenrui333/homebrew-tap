class Tenderly < Formula
  desc "Debugging, monitoring & tracking smart contract execution"
  homepage "https://tenderly.co/"
  url "https://github.com/Tenderly/tenderly-cli/archive/refs/tags/v1.6.8.tar.gz"
  sha256 "a6a74cfb74f2f390af4926f3604f136f334191e028e5ab5e6d98f64ae8addc68"
  license "GPL-3.0-only"
  head "https://github.com/Tenderly/tenderly-cli.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ee407046b659138715c9f96ffd3f427a458734b205d5fc33ff16775fc5bbc511"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ee407046b659138715c9f96ffd3f427a458734b205d5fc33ff16775fc5bbc511"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ee407046b659138715c9f96ffd3f427a458734b205d5fc33ff16775fc5bbc511"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e9f1160d41e80d8e4046800fbc318a8aacd65d9d29ae0438a5e176da644b670a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "edf4796e97df58c325260bead4cc783208669f0baad2f7fb2b760839e51ce2ab"
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
