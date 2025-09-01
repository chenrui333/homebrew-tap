class Dstp < Formula
  desc "Run common networking tests against your site"
  homepage "https://github.com/ycd/dstp"
  url "https://github.com/ycd/dstp/archive/refs/tags/v0.4.23.tar.gz"
  sha256 "1ab45012204cd68129fd05723dd768ea4a9ce08e2f6c2fa6468c2c88ab65c877"
  license "MIT"
  head "https://github.com/ycd/dstp.git", branch: "main"

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/dstp"
  end

  test do
    assert_match "HTTPS: got 200 OK", shell_output("#{bin}/dstp example.com --dns 1.1.1.1")
  end
end
