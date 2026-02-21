class Starcharts < Formula
  desc "Plot your repository stars over time"
  homepage "https://starchart.cc/"
  url "https://github.com/caarlos0/starcharts/archive/refs/tags/v1.11.0.tar.gz"
  sha256 "2c98d43d5056a35eaf21455754b6253b526f5c0c7e4b8517407e247257e1beaf"
  license "MIT"
  head "https://github.com/caarlos0/starcharts.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "55818e8d35f6293a7dda24d9db6419d312969ecb425b2dda2c4ce56c65b20e92"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d4cf843efcab030655670593a554916598098028a26c052e29a0652ceb19b6fb"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d4508f5bdf7345f8734dcd1e0e313e53e17d2268be6fb82629e2dc3e53802886"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "bea9f2b64bbf2a4f2e942169195a4f7307ee677e26055fe87ff9713b1d2e2d43"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ddc105545ef06f940fb3ce619e49cf8a42324b87b78e6b705513327284578d33"
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
