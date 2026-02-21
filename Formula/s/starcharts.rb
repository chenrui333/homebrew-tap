class Starcharts < Formula
  desc "Plot your repository stars over time"
  homepage "https://starchart.cc/"
  url "https://github.com/caarlos0/starcharts/archive/refs/tags/v1.11.0.tar.gz"
  sha256 "2c98d43d5056a35eaf21455754b6253b526f5c0c7e4b8517407e247257e1beaf"
  license "MIT"
  head "https://github.com/caarlos0/starcharts.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "767d9ed0e5839c461577d52d7a1a0645760ebee052483d01628ffdd3231ffbe1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7db0026adac837e6fe6240876d004ea0eab1f23b6fdd5c06a718aedae93f5e02"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2b5991aa577c3cd075abd843d0d6973e43f4ffbf411d05137fe7aac7176eae7c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f7bfb9de236effd7665c0aa0ff2c37da2b2e8538921e18ca9ae3a111e9d5561d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f3b4a179efcaea6778758497adbe1a8ab78b6049bd69f6161789c5a50f7b7027"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.version=#{version} -X main.commit=#{tap.user} -X main.date=#{time.iso8601}"

    system "go", "mod", "tidy"
    system "go", "build", *std_go_args(ldflags:)
  end

  test do
    pid = spawn bin/"starcharts"

    sleep 2

    begin
      output = shell_output("curl -s http://localhost:3000")
      assert_match "meta name=\"description\" content=\"StarCharts\"", output.strip
    ensure
      Process.kill("TERM", pid)
      Process.wait(pid)
    end
  end
end
