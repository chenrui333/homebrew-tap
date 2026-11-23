class IptrafNg < Formula
  desc "Console-based network monitoring program for Linux"
  homepage "https://github.com/iptraf-ng/iptraf-ng"
  url "https://github.com/iptraf-ng/iptraf-ng/archive/refs/tags/v1.2.2.tar.gz"
  sha256 "75fd653745ea0705995c25e6c07b34252ecc2563c6a91b007a3a8c26f29cc252"
  license "GPL-2.0-or-later"
  head "https://github.com/iptraf-ng/iptraf-ng.git", branch: "master"

  depends_on :linux
  depends_on "ncurses"

  deny_network_access!

  def install
    system "make", "prefix=#{prefix}"
    system "make", "install", "prefix=#{prefix}"
  end

  test do
    assert_match version.to_s, File.binread(sbin/"iptraf-ng")
    output = shell_output("#{sbin}/iptraf-ng -i lo 2>&1", 129)
    assert_match "This program can be run only by the system administrator", output
  end
end
