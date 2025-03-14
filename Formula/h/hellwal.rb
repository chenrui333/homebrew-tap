class Hellwal < Formula
  desc "Pywal-like color palette generator, but faster and in C"
  homepage "https://github.com/danihek/hellwal"
  url "https://github.com/danihek/hellwal/archive/refs/tags/v1.0.3.tar.gz"
  sha256 "2b841d03fe057e30cd1200283361f5ca2f0320aaf2ae7828ace3ce6721633ea8"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d7786e5c8a24200904076d515081efeca8bc338ca72292be70bf338a6a572430"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "811455e39e7617a6d0f22121694cd6af5b29f4ec9ddfaee8f531fb160946c56b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0f6e2bbaa3ee2a2d163b7f70f808c984780e4c9c83ebdee96cc669d813e5536b"
  end

  depends_on macos: :sonoma # failed on ventura

  patch :DATA

  def install
    system "make"
    bin.install "hellwal"
    doc.install "templates", "themes"
  end

  test do
    resource "test_image" do
      url "https://rustfoundation.org/wp-content/uploads/2024/07/cropped-rust-lang-logo-black-300x300.png"
      sha256 "62df7205f3fc29db0a47bbd328789d64325bd88ea62b0bcc7418589dca7337c4"
    end

    testpath.install resource("test_image")
    system bin/"hellwal", "--image", testpath/"cropped-rust-lang-logo-black-300x300.png"

    system bin/"hellwal", "--help"
  end
end

__END__
diff --git a/Makefile b/Makefile
index c19c28f..88be1cf 100644
--- a/Makefile
+++ b/Makefile
@@ -6,10 +6,10 @@ LDFLAGS = -lm
 DESTDIR = /usr/local/bin

 hellwal: hellwal.c
-	$(CC) $(CFLAGS) $(LDFLAGS) hellwal.c -o hellwal
+	$(CC) $(CFLAGS) hellwal.c $(LDFLAGS) -o hellwal

 debug: hellwal.c
-	$(CC) $(CFLAGS) -ggdb $(LDFLAGS) hellwal.c -o hellwal
+	$(CC) $(CFLAGS) -ggdb hellwal.c $(LDFLAGS) -o hellwal

 clean:
 	rm hellwal
