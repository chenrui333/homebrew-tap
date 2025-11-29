class Ticker < Formula
  desc "Terminal stock ticker with live updates and position tracking"
  homepage "https://github.com/achannarasappa/ticker"
  url "https://github.com/achannarasappa/ticker/archive/refs/tags/v5.1.0.tar.gz"
  sha256 "8c2468d0dcf0c585a43235cabed7c5a404dac20d58c945a03fdf40fb1345f0ac"
  license "GPL-3.0-only"
  head "https://github.com/achannarasappa/ticker.git", branch: "master"

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/achannarasappa/ticker/v5/cmd.Version=#{version}"
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"ticker", "completion", shells: [:bash, :zsh, :fish, :pwsh])
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
