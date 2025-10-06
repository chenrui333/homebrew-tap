class Rawhide < Formula
  desc "Find files using pretty C expressions"
  homepage "https://raf.org/rawhide/"
  url "https://github.com/raforg/rawhide/releases/download/v3.3/rawhide-3.3.tar.gz"
  sha256 "a51a1360ce4763838b29a548a8e49dcf47a93a922bf1df05c8b7d50ecb9ab09d"
  license "GPL-3.0-or-later"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ab9e07333a57f46f1fd34ad3b0fce4aa26526a85c72bcf09c6a80466974cd3f7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bdbfab762c066b652d38aaca99730605f12bcd5a7f72213520772000f4b83776"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1aac640030b8adcd20450b85965579a2422034aaeb1a4abb4dd6f6c324b069d5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "38131efb65f82f8381a5d0a1a56fd837b18a78cce52a8d42275cf6dcd1efed34"
  end

  on_linux do
    depends_on "pcre2"
  end

  def install
    system "./configure", "--prefix=#{prefix}"

    inreplace "Makefile" do |s|
      s.gsub!(/^PREFIX\s*=\s*.*$/, "PREFIX = #{prefix}")
      s.gsub!(/^ETCDIR\s*=\s*.*$/, "ETCDIR = #{etc}")
    end

    system "make"
    system "make", "install-bin"
    system "make", "install-man"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/rh --version")
  end
end
