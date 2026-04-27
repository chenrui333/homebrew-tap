class Ticker < Formula
  desc "Terminal stock ticker with live updates and position tracking"
  homepage "https://github.com/achannarasappa/ticker"
  url "https://github.com/achannarasappa/ticker/archive/refs/tags/v5.2.1.tar.gz"
  sha256 "774b060941aed0773b49633bb5b009247ff8122ee7d45ddfe406940c635f6926"
  license "GPL-3.0-only"
  head "https://github.com/achannarasappa/ticker.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "61e1bf97281ed96c01ba95724b443cc7f16d1cd6f8a630844774e1d747e5534f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "61e1bf97281ed96c01ba95724b443cc7f16d1cd6f8a630844774e1d747e5534f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "61e1bf97281ed96c01ba95724b443cc7f16d1cd6f8a630844774e1d747e5534f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7593e9325b18f222e6dcd6072f9e97e46b97de9f5acd6612e3691873dc83d998"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8f7c838fae54878184ad3320f1614c323924ab053fdd700aca7111855ab13dc0"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/achannarasappa/ticker/v5/cmd.Version=#{version}"
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"ticker", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/ticker --version")

    (testpath/".ticker.yaml").write <<~YAML
      watchlist:
        - AAPL
    YAML

    output = shell_output("#{bin}/ticker print summary --config #{testpath}/.ticker.yaml")
    assert_equal "0.000000", JSON.parse(output)["total_value"]
  end
end
