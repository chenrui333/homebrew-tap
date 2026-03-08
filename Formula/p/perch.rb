class Perch < Formula
  desc "Terminal social client for Mastodon and Bluesky"
  homepage "https://perch.ricardodantas.me/"
  url "https://github.com/ricardodantas/perch/archive/refs/tags/v0.3.3.tar.gz"
  sha256 "c4a6b6212f16c6ddd4d37d131235997da0cdb9334977fd2c45326726c158736d"
  license "GPL-3.0-or-later"
  revision 1

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: ".")
  end

  test do
    assert_match version.to_s, shell_output("HOME=#{testpath} #{bin}/perch --version")
    assert_match "No accounts configured.", shell_output("HOME=#{testpath} #{bin}/perch accounts")
  end
end
