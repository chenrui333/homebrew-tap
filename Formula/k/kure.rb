class Kure < Formula
  desc "CLI password manager with sessions"
  homepage "https://github.com/GGP1/kure"
  url "https://github.com/GGP1/kure/archive/refs/tags/v1.3.0.tar.gz"
  sha256 "e9e1fdd94fa152c0707e1526424d075e29840e5a53ad7b8b81ff28210fe98a48"
  license "Apache-2.0"
  head "https://github.com/GGP1/kure.git", branch: "master"

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.version=#{version} -X main.commit=#{tap.user} -X main.date=#{time.iso8601}"
    system "go", "build", *std_go_args(ldflags:)
  end

  test do
    system bin/"kure", "--version"
    assert_match "Password:", shell_output("#{bin}/kure gen -l 20")
  end
end
