class Ticker < Formula
  desc "Terminal stock ticker with live updates and position tracking"
  homepage "https://github.com/achannarasappa/ticker"
  url "https://github.com/achannarasappa/ticker/archive/refs/tags/v5.2.0.tar.gz"
  sha256 "e2cfb09173cce87cb68c42331a6d4e23f5fd6135980e17c2dd37bfd23432cea3"
  license "GPL-3.0-only"
  head "https://github.com/achannarasappa/ticker.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d56a3495dab73d5ade8a512ae2b3c37dd3333f858a35f1f752ba735fbd4fb17a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d56a3495dab73d5ade8a512ae2b3c37dd3333f858a35f1f752ba735fbd4fb17a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d56a3495dab73d5ade8a512ae2b3c37dd3333f858a35f1f752ba735fbd4fb17a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "df511f19a0b66e55dc1929a7915eca32ffc34ffd10a76ebe6ab4bf326ad32912"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0a96e4d3e8a8e534f7f1c6f5e58c1ae4bcb1812a36e2d792fa495b4a28143c77"
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
