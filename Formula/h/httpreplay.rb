class Httpreplay < Formula
  desc "Replay HTTP requests from a tape file"
  homepage "https://github.com/roy2220/httpreplay"
  url "https://github.com/roy2220/httpreplay/archive/refs/tags/v0.7.1.tar.gz"
  sha256 "a1a8b9e6113b3424f55936c2a7a856f7cd6843bfb432b1b36024bd6368e8afb6"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "17de95b8b972ddd3df610389a4baea79aa74e67e7193555397a604f025522e55"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "17de95b8b972ddd3df610389a4baea79aa74e67e7193555397a604f025522e55"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "17de95b8b972ddd3df610389a4baea79aa74e67e7193555397a604f025522e55"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "97e6f336b461565deae9f31aeddfa483e128f12d62a9f93500704d49e3992d6e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6ef8384affb2d918e49288cb78c36065aea8b2233c42a46f2dbae66bb04dea77"
  end
  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(output: bin/"httpreplay")
  end

  test do
    (testpath/"requests.txt").write <<~EOS
      https://example.com/api/status
      https://example.com/api/post -X POST -H "Content-Type: application/json" -d '{"key":"value"}'
    EOS

    output = shell_output("#{bin}/httpreplay requests.txt -d -q 1 -c 1 2>&1")
    assert_match "<dry-run> http request: method=\"GET\" url=\"https://example.com/api/status\"", output
    assert_match "final progress: tapePosition=2", output
    assert_path_exists testpath/"requests.txt.httpreplay-pos.dry-run"
  end
end
