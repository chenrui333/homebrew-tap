class Dstp < Formula
  desc "Run common networking tests against your site"
  homepage "https://github.com/ycd/dstp"
  url "https://github.com/ycd/dstp/archive/refs/tags/v0.4.23.tar.gz"
  sha256 "1ab45012204cd68129fd05723dd768ea4a9ce08e2f6c2fa6468c2c88ab65c877"
  license "MIT"
  head "https://github.com/ycd/dstp.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b82667d3f17e60670e89e610ba39ce374c093b53f81a5a04e53711b9efc43166"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3c67377bb3c96e0a6718b660b2ea481a83cd22ce42315fd54dc16525d08cea54"
    sha256 cellar: :any_skip_relocation, ventura:       "ef17df1272cbfbcf710aee30507657c482e70aae5106732dd73b0f6742f642ae"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "dc13245fb0fd7a5875e16a8c01f804dbd0dc8a07178926228db936501905aebf"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/dstp"
  end

  test do
    assert_match "HTTPS: got 200 OK", shell_output("#{bin}/dstp example.com --dns 1.1.1.1")
  end
end
