class Tenderly < Formula
  desc "Debugging, monitoring & tracking smart contract execution"
  homepage "https://tenderly.co/"
  url "https://github.com/Tenderly/tenderly-cli/archive/refs/tags/v1.6.10.tar.gz"
  sha256 "f6fda133553e2d298dfccfb0065480f541ab82fd2546262d894f40808e920cae"
  license "GPL-3.0-only"
  head "https://github.com/Tenderly/tenderly-cli.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e93f80a6bbd83759b84accda0ba6ea8e2aca8292d5b9b2c4d9d057cabf748b0b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e93f80a6bbd83759b84accda0ba6ea8e2aca8292d5b9b2c4d9d057cabf748b0b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e93f80a6bbd83759b84accda0ba6ea8e2aca8292d5b9b2c4d9d057cabf748b0b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d6a5025ccbcef16df40402748dd1f463744432a955bc4c31e2ed84f9d674ac5e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "decd4ae76df3c197991a79f6415f05ce31d991cabd4aa83ffb97077e19ffa8b4"
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
