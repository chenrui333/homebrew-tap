class Ticker < Formula
  desc "Terminal stock ticker with live updates and position tracking"
  homepage "https://github.com/achannarasappa/ticker"
  url "https://github.com/achannarasappa/ticker/archive/refs/tags/v5.3.0.tar.gz"
  sha256 "c11e522a309feee522cf3af22d1581a5a1ef338bb6a597fc0c1839b6f0142b42"
  license "GPL-3.0-only"
  head "https://github.com/achannarasappa/ticker.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f0f0d8ae2a5829fce999395012ca08a8656de9fe7c5e9aaebb3aeff85320220d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f0f0d8ae2a5829fce999395012ca08a8656de9fe7c5e9aaebb3aeff85320220d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f0f0d8ae2a5829fce999395012ca08a8656de9fe7c5e9aaebb3aeff85320220d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6a5d4dd05673f849efeff43412c0e120bd76f94b9d50742648a609645e5a32df"
    sha256 cellar: :any,                 x86_64_linux:  "6b035e3bac034b7b0b90daf28fa7f6c3b14b07a2d2f17ba71ebeee69427c7641"
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
