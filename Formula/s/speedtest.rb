class Speedtest < Formula
  desc "Test Internet Speed using speedtest.net"
  homepage "https://tenderly.co/"
  url "https://github.com/showwin/speedtest-go/archive/refs/tags/v1.7.10.tar.gz"
  sha256 "70a2937d0759820fe7ee8f61b960d60c07b34c0d783ed11c0065b68fe2964aea"
  license "MIT"
  head "https://github.com/showwin/speedtest-go.git", branch: "master"

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.version=#{version} -X main.commit=#{tap.user} -X main.date=#{time.iso8601}"
    system "go", "build", *std_go_args(ldflags:)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/speedtest --version 2>&1")

    system bin/"speedtest"
  end
end
