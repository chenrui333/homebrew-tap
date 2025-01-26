class UmkaLang < Formula
  desc "Statically typed embeddable scripting language"
  homepage "https://github.com/vtereshkov/umka-lang"
  url "https://github.com/vtereshkov/umka-lang/archive/refs/tags/v1.5.1.tar.gz"
  sha256 "d5f4071f142ecb8859663e41654594b9d53fddfc0f60f9e9dd0fedda9f921b99"
  license "BSD-2-Clause"
  head "https://github.com/vtereshkov/umka-lang.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any,                 arm64_sequoia: "da12c3692921210b7278127746ab56a024eead8d23593105ce268dfa55a912c8"
    sha256 cellar: :any,                 arm64_sonoma:  "1fc954a7257256dd1352a9db09f4a674cdff35e35628d823af37edf8c1f8ba35"
    sha256 cellar: :any,                 ventura:       "0b3f9a6fd922e0a360eb8a2a6be55036608b04b3f75594622ed75fa390d2cebc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cb177b6a8fc6fb5a9f990070c117b4ad0b2e271036859d4b448ac54dd0ddffc2"
  end

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
