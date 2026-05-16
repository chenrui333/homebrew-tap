class Gecit < Formula
  desc "DPI bypass tool using fake TLS ClientHello packets"
  homepage "https://github.com/boratanrikulu/gecit"
  url "https://github.com/boratanrikulu/gecit/archive/refs/tags/v0.1.4.tar.gz"
  sha256 "09f5dcdddcab4bab87c5e704f837060f41a8f99ba36959576e9ae16f530eae3b"
  license "GPL-3.0-only"
  head "https://github.com/boratanrikulu/gecit.git", branch: "main"

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/gecit"
  end

  test do
    output = shell_output("#{bin}/gecit --help 2>&1")
    assert_match "gecit", output.downcase
  end
end
