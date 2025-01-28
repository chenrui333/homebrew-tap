class UmkaLang < Formula
  desc "Statically typed embeddable scripting language"
  homepage "https://github.com/vtereshkov/umka-lang"
  url "https://github.com/vtereshkov/umka-lang/archive/refs/tags/v1.5.2.tar.gz"
  sha256 "9ea56cc32e1556989b81cd3db5d0ae533ac3af708ec5c742c36628d6310b52c4"
  license "BSD-2-Clause"
  head "https://github.com/vtereshkov/umka-lang.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any,                 arm64_sequoia: "dcdd0492860e986ed68945509bdef8c31cdf5a149e3a0c6d1a318fb83af19d95"
    sha256 cellar: :any,                 arm64_sonoma:  "58f4271a9c0f5b504b3d34f5568c08db43cda00b31bd6a1f8f66a77f49831cc7"
    sha256 cellar: :any,                 ventura:       "47d260c87915e39c80c2099ad4f1e14d5dc71fc4d502323e478d0de203808618"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "621b0abd4c3cb576a226dce8f04c5482f4d0da33ec50fbeb77d1d58bbafec140"
  end

  def install
    system "make", "install", "PREFIX=#{prefix}"
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
