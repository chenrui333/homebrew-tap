class Ticker < Formula
  desc "Terminal stock ticker with live updates and position tracking"
  homepage "https://github.com/achannarasappa/ticker"
  url "https://github.com/achannarasappa/ticker/archive/refs/tags/v5.3.0.tar.gz"
  sha256 "c11e522a309feee522cf3af22d1581a5a1ef338bb6a597fc0c1839b6f0142b42"
  license "GPL-3.0-only"
  head "https://github.com/achannarasappa/ticker.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5fa575a10595113a8d746657127be90d0dfc4724c87dc1b21bab9406b63b86ff"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5fa575a10595113a8d746657127be90d0dfc4724c87dc1b21bab9406b63b86ff"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8898f8b682b118dd0492435484521b0714c4088b50ed79233794be33407299bb"
    sha256 cellar: :any,                 x86_64_linux:  "8221ae0bdb1751d2c77e94f89bb0ad646d0386a7cfb59cb399145ae031c86f9c"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    ldflags = "-s -w -X github.com/achannarasappa/ticker/v5/cmd.Version=#{version}"
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"ticker", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/ticker --version")

    # Config validation runs before the symbol list and quotes are downloaded.
    (testpath/".ticker.yaml").write <<~YAML
      lots:
        - symbol: AAPL
          quantity: 0
          unit_cost: 1
    YAML

    output = shell_output("#{bin}/ticker print summary --config #{testpath}/.ticker.yaml 2>&1", 1)
    assert_match "lot #1 for symbol 'AAPL' in group 'default' has invalid quantity", output
  end
end
