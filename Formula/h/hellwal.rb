class Hellwal < Formula
  desc "Pywal-like color palette generator, but faster and in C"
  homepage "https://github.com/danihek/hellwal"
  url "https://github.com/danihek/hellwal/archive/refs/tags/v1.0.2.tar.gz"
  sha256 "eff95d7a0403fc06d57917e4b4d4dbf897a6f0300104592cf95be7b54c83bc90"
  license "MIT"

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
