class UmkaLang < Formula
  desc "Statically typed embeddable scripting language"
  homepage "https://github.com/vtereshkov/umka-lang"
  url "https://github.com/vtereshkov/umka-lang/archive/refs/tags/v1.5.1.tar.gz"
  sha256 "d5f4071f142ecb8859663e41654594b9d53fddfc0f60f9e9dd0fedda9f921b99"
  license "BSD-2-Clause"
  head "https://github.com/vtereshkov/umka-lang.git", branch: "master"

  # fix dynlib, https://github.com/vtereshkov/umka-lang/pull/482
  patch do
    url "https://github.com/vtereshkov/umka-lang/commit/90fa58ba5a99b8e29a14a22b8fe594c4325bed47.patch?full_index=1"
    sha256 "607953aa7be3fa5f3c0985a65ccb24d32804f8e486c0dad724db2ba3fd197cbe"
  end

  def install
    system "make", "all"
    bin.install "build/umka"
    # include libraries
    lib.install "build/libumka.a"
    lib.install "build/#{shared_library("libumka")}"
    include.install Dir["build/include/*"]
  end

  test do
    (testpath/"hello.um").write <<~EOS
      fn main() {
        printf("Hello Umka!")
      }
    EOS

    assert_match "Hello Umka!", shell_output("#{bin}/umka #{testpath}/hello.um")

    (testpath/"test.c").write <<~C
      #include <stdio.h>
      #include <umka_api.h>

      int main(void) {
          printf("Umka version: %s\\n", umkaGetVersion());
          return 0;
      }
    C

    system ENV.cc, "test.c", "-I#{include}", "-L#{lib}", "-lumka", "-o", "test"
    system "./test"
  end
end
