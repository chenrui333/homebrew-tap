class Speedtest < Formula
  desc "Test Internet Speed using speedtest.net"
  homepage "https://github.com/showwin/speedtest-go"
  url "https://github.com/showwin/speedtest-go/archive/refs/tags/v1.8.3.tar.gz"
  sha256 "48d01137468da9d419a3940a652803dafd8a6820abcd985b85c9d0c86b417ba3"
  license "MIT"
  head "https://github.com/showwin/speedtest-go.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "735f962be55aeb734b60f13b72fb74c841cd877c5ddf8efc007237ab20c356eb"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "735f962be55aeb734b60f13b72fb74c841cd877c5ddf8efc007237ab20c356eb"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "735f962be55aeb734b60f13b72fb74c841cd877c5ddf8efc007237ab20c356eb"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "400efb1e0859e443d1e987d84d6be95716daa02fb46dd7c83f27e3a500837e56"
    sha256 cellar: :any,                 x86_64_linux:  "f524b4fa68d8df3da8484e6df49ba5dca442ee32f9b3d043dcae99a3bc15987b"
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
