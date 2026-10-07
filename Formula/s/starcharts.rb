class Starcharts < Formula
  desc "Plot your repository stars over time"
  homepage "https://starchart.cc/"
  url "https://github.com/caarlos0/starcharts/archive/refs/tags/v1.11.0.tar.gz"
  sha256 "2c98d43d5056a35eaf21455754b6253b526f5c0c7e4b8517407e247257e1beaf"
  license "MIT"
  head "https://github.com/caarlos0/starcharts.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "45b1148d5358fe8c436ab3fb061eccc73c8f9cd7d8212be4db19b430c927b9e6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "165a00eccea1cd72dd434d7aecd6d29d26392949ab67a23c15ec1e6f61fe78cc"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "80d0d951f87800f550a4442de99de625a397cb012bb8c8b42b739caff4fa637f"
    sha256 cellar: :any,                 x86_64_linux:  "99295f49e9562292f622ebc806dbf2901e50b5f6de3c3955e9a57cca6e04e1a5"
  end

  depends_on "go" => :build

  # The test fetches the index page from the local web server over loopback.
  allow_network_access! :test

  def fetch
    system "go", "mod", "download"
  end

  def install
    ldflags = "-s -w -X main.version=#{version} -X main.commit=#{tap.user} -X main.date=#{time.iso8601}"
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
