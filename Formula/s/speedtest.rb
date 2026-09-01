class Speedtest < Formula
  desc "Test Internet Speed using speedtest.net"
  homepage "https://github.com/showwin/speedtest-go"
  url "https://github.com/showwin/speedtest-go/archive/refs/tags/v1.8.3.tar.gz"
  sha256 "48d01137468da9d419a3940a652803dafd8a6820abcd985b85c9d0c86b417ba3"
  license "MIT"
  head "https://github.com/showwin/speedtest-go.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3a309f6398bb9cdee00e340583ec466f6ae70ace93c75c2661a41e9db2cc2fa8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3a309f6398bb9cdee00e340583ec466f6ae70ace93c75c2661a41e9db2cc2fa8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3a309f6398bb9cdee00e340583ec466f6ae70ace93c75c2661a41e9db2cc2fa8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "92abd7a375abf1152655147e43c50c24becf9af39d9bb1da342cac63feb0f07b"
    sha256 cellar: :any,                 x86_64_linux:  "f8ba22cc71bd97141c154d97d01b9a2ad2a8b0ba5e0adda9967d2aba39deacb4"
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
