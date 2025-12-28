class Ticker < Formula
  desc "Terminal stock ticker with live updates and position tracking"
  homepage "https://github.com/achannarasappa/ticker"
  url "https://github.com/achannarasappa/ticker/archive/refs/tags/v5.1.0.tar.gz"
  sha256 "8c2468d0dcf0c585a43235cabed7c5a404dac20d58c945a03fdf40fb1345f0ac"
  license "GPL-3.0-only"
  head "https://github.com/achannarasappa/ticker.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "badd168f5c4c64cf020baf69d723f259d8e39f9de873717f0c9a63631b46d1da"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "badd168f5c4c64cf020baf69d723f259d8e39f9de873717f0c9a63631b46d1da"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "badd168f5c4c64cf020baf69d723f259d8e39f9de873717f0c9a63631b46d1da"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7e5aa78ab67943b18461bb5ad7bdc1b75c5bf1f69472637a7a0d87ca7a5b5991"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8235949a32788a76abfb164387d3c581751c875305c909902ed9f78101b9b45b"
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
