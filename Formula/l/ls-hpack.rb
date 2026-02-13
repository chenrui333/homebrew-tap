class LsHpack < Formula
  desc "HTTP/2 HPACK header compression library"
  homepage "https://github.com/litespeedtech/ls-hpack"
  url "https://github.com/litespeedtech/ls-hpack/archive/refs/tags/v2.3.4.tar.gz"
  sha256 "4abeeb786d6211d0aaf13ef3df7651c765c2ffb58cd226ec5c9e6e8b6d801ca1"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "174b2ba3db2da8fb24ff7a019efc1facf64186ba132a026b3a0918c617a3aada"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e5607e6adbceaf4400fa89414644c45a8172281e0480e90766cf07e9c27c1fa4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8c0e6dd2a5ac1a85ca6a62797f83d757a3fe4ae5094c6a3ac1b81b15c6c2975a"
    sha256 cellar: :any_skip_relocation, sequoia:       "7709b1c11b0979b0d3a079cc749391483dd0b48ccb5d3b54771ad5843e0d945c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c07db604b3170a8f21fa45169af39e71fd52eeb710e80c2ab88ee578f74a7274"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "201e2612304554a6022911c7e44e76b41a8b2e46cb74dc4e6f3975951cd541b8"
  end

  depends_on "cmake" => :build

  def install
    # Upstream has no install() rules in CMakeLists, so install artifacts manually.
    # https://github.com/litespeedtech/ls-hpack/issues/21
    system "cmake", "-S", ".", "-B", "build",
                  "-DCMAKE_BUILD_TYPE=Release",
                  "-DCMAKE_POLICY_VERSION_MINIMUM=3.5",
                  "-DSHARED=1",
                  "-DLSHPACK_XXH=1",
                  *std_cmake_args
    system "cmake", "--build", "build"

    lib.install "build/#{shared_library("libls-hpack")}"
    include.install "lshpack.h", "lsxpack_header.h"
  end

  test do
    (testpath/"test.c").write <<~C
      #include <assert.h>
      #include <lshpack.h>

      int main(void) {
        struct lshpack_dec dec;
        lshpack_dec_init(&dec);
        lshpack_dec_cleanup(&dec);
        assert(LSHPACK_MAJOR_VERSION >= 2);
        return 0;
      }
    C

    system ENV.cc, "test.c", "-I#{include}", "-L#{lib}", "-lls-hpack", "-o", "test"
    system "./test"
  end
end
