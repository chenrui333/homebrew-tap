class Speedtest < Formula
  desc "Test Internet Speed using speedtest.net"
  homepage "https://tenderly.co/"
  url "https://github.com/showwin/speedtest-go/archive/refs/tags/v1.7.10.tar.gz"
  sha256 "70a2937d0759820fe7ee8f61b960d60c07b34c0d783ed11c0065b68fe2964aea"
  license "MIT"
  head "https://github.com/showwin/speedtest-go.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2b3b730850b330edf5f1f4ae8c77ef6b23eb08c5c696cb9658ddf1bc4b03c78c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "883b0e19be9f3471d577158bed2c21b803a63e278f9d0a7d4d47e77c7f270f7f"
    sha256 cellar: :any_skip_relocation, ventura:       "1584f069f6901104bbb1d6c668ded91fb18d170ba45afe1f3bada3f19f7ea2fb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6faac3aa52f6d2784f28d191edf3b17e6af9544ec5d6847b6ca196a2af1eaffd"
  end

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
