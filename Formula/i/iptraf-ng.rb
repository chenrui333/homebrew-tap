class IptrafNg < Formula
  desc "Console-based network monitoring program for Linux"
  homepage "https://github.com/iptraf-ng/iptraf-ng"
  url "https://github.com/iptraf-ng/iptraf-ng/archive/refs/tags/v1.2.2.tar.gz"
  sha256 "75fd653745ea0705995c25e6c07b34252ecc2563c6a91b007a3a8c26f29cc252"
  license "GPL-2.0-or-later"
  head "https://github.com/iptraf-ng/iptraf-ng.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    manifest_sha256 "0e94deb670d41235dfa9fb97873996cf431c4e588c97f8a9c4ae321144573e6e"
    sha256 cellar: :any, arm64_linux:  "ee0fce9644db372c8877c626444ec84f1e9b3098c9261a6f64cce8bc33ba05a1"
    sha256 cellar: :any, x86_64_linux: "6b6f9fedf3451c73db32ac2f232d43ef5e5b95727aa5b0264ebac4168823ef09"
  end

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
