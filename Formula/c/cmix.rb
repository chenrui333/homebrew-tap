class Cmix < Formula
  desc "Data compression program with high compression ratio"
  homepage "https://www.byronknoll.com/cmix.html"
  url "https://github.com/byronknoll/cmix/archive/refs/tags/v21.tar.gz"
  sha256 "c0ff50f24604121bd7ccb843045c0946db1077cfb9ded10fe4c181883e6dbb42"
  license "GPL-3.0-or-later"

  def install
    if Hardware::CPU.arm?
      # On ARM, we need to prevent x86 SIMD code from being compiled
      inreplace "src/models/fxcmv1.cpp" do |s|
        s.gsub! "#include <immintrin.h>", "// #include <immintrin.h> // Disabled on ARM"
        s.gsub! "typedef __m128i XMM;", "// typedef __m128i XMM; // Disabled on ARM"
        s.gsub! "typedef __m256i YMM;", "// typedef __m256i YMM; // Disabled on ARM"
      end
      # Also fix the Makefile
      inreplace "Makefile" do |s|
        s.gsub! "CC = clang++-17", "CC = #{ENV.cxx}"
        s.gsub! "-march=native", ""
      end
    else
      # On x86, just replace the compiler
      inreplace "Makefile", "CC = clang++-17", "CC = #{ENV.cxx}"
    end

    system "make"
    bin.install "cmix"
  end

  test do
    (testpath/"foo").write "test"
    system bin/"cmix", "-c", "foo", "foo.cmix"
    system bin/"cmix", "-d", "foo.cmix", "foo.unpacked"
    assert_equal "test", shell_output("cat foo.unpacked")
  end
end
