class Wifitui < Formula
  desc "Pretty feed reader (ATOM/RSS) that stores articles in Markdown files"
  homepage "https://github.com/shazow/wifitui"
  url "https://github.com/shazow/wifitui/archive/refs/tags/v0.4.1.tar.gz"
  sha256 "7cefb600618122e08e2c4569b9162a94931a65758fc01be2280b08c9be978b67"
  license "MIT"
  head "https://github.com/CrociDB/bulletty.git", branch: "main"

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.Version=#{version}")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/wifitui --version")

    system bin/"wifitui", "list"
  end
end
