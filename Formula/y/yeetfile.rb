class Yeetfile < Formula
  desc "Encrypted file sharing and vault service for web and CLI"
  homepage "https://yeetfile.com/"
  url "https://github.com/benbusby/yeetfile/archive/refs/tags/v0.2.0.tar.gz"
  sha256 "ab581b920bd7f52f00c5baed497f51cdaf5608c32340949587ee0769a6fa81ca"
  license "AGPL-3.0-only"
  head "https://github.com/benbusby/yeetfile.git", branch: "main"

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cli"
  end

  test do
    output = shell_output("#{bin}/yeetfile account")
    assert_match "You are not logged in. Use the 'login' or 'signup' commands to continue.", output
  end
end
