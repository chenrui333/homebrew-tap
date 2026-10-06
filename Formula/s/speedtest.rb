class Speedtest < Formula
  desc "Test Internet Speed using speedtest.net"
  homepage "https://github.com/showwin/speedtest-go"
  url "https://github.com/showwin/speedtest-go/archive/refs/tags/v1.8.3.tar.gz"
  sha256 "48d01137468da9d419a3940a652803dafd8a6820abcd985b85c9d0c86b417ba3"
  license "MIT"
  head "https://github.com/showwin/speedtest-go.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "098f4e0ddc39ed57e76f1043f6d9aa463c7598f99214ae7b0cf8b6e56df73d42"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "098f4e0ddc39ed57e76f1043f6d9aa463c7598f99214ae7b0cf8b6e56df73d42"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d56e6044e0024f26b482f41120a82a88dc959eda3ba827bf7826703ff5d65afc"
    sha256 cellar: :any,                 x86_64_linux:  "0585df992a9d261f6f65e4fbb5f750593f2f3a5aa85ea912d6e6f6a81c9791f9"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    ldflags = "-s -w -X main.version=#{version} -X main.commit=#{tap.user} -X main.date=#{time.iso8601}"
    system "go", "build", *std_go_args(ldflags:)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/speedtest --version 2>&1")

    # A real speed test needs speedtest.net; the predefined city table is built in
    output = shell_output("#{bin}/speedtest --city-list")
    assert_match "Available city labels", output
    assert_match(/\(jp\)\s+tokyo\s+\[35\.680938, 139\.7674114\]/, output)
  end
end
