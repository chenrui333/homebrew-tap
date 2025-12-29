class Ticker < Formula
  desc "Terminal stock ticker with live updates and position tracking"
  homepage "https://github.com/achannarasappa/ticker"
  url "https://github.com/achannarasappa/ticker/archive/refs/tags/v5.2.0.tar.gz"
  sha256 "e2cfb09173cce87cb68c42331a6d4e23f5fd6135980e17c2dd37bfd23432cea3"
  license "GPL-3.0-only"
  head "https://github.com/achannarasappa/ticker.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "17d17c570badf5f8b66761e5e39e08058a155a17058c8d8213076ad89bb2e457"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "17d17c570badf5f8b66761e5e39e08058a155a17058c8d8213076ad89bb2e457"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "17d17c570badf5f8b66761e5e39e08058a155a17058c8d8213076ad89bb2e457"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c1796e23a238baad3cc7c56f14998a6ca68b7d3bac94c570422c67e5a2ac8265"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4038b30834bfc7a07c61c1f476e393ad7a5d53981cec5792edcc4443ea1f47cb"
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
