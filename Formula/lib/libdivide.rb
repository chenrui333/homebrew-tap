class Libdivide < Formula
  desc "Optimized integer division"
  homepage "https://libdivide.com"
  url "https://github.com/ridiculousfish/libdivide/archive/refs/tags/v5.1.tar.gz"
  sha256 "fec2e4141878c58eb92cfcd478accc3b7f34b39491c1e638566f083d378cc7d4"
  license any_of: ["Zlib", "BSL-1.0"]
  head "https://github.com/ridiculousfish/libdivide.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6b090bb73ec50e350fc80914988eae8107a1c6d246a0cf56cad3077211e16588"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6f9650bd5b4cdd208c42f3e867f028bc8d19c2ed7825da690fbb5d48376d1948"
    sha256 cellar: :any_skip_relocation, ventura:       "c878934c1a1ea10ded62353c8a5180a5b4fae17d251121289bfba23777ca85b0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8c9c76ddc3ac1e68b45ddb1dff01aec3f3da7821bf5868b3d15bf7a1deaf51a2"
  end

  depends_on "cmake" => :build

  def install
    # Skip `cmake --build`, as this is only for building tests.
    system "cmake", "-S", ".", "-B", "build", "-DBUILD_TESTS=OFF", *std_cmake_args
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"libdivide-test.c").write <<~C
      #include "libdivide.h"
      #include <assert.h>

      int sum_of_quotients(const int *numers, size_t count, int d) {
        int result = 0;
        struct libdivide_s32_t fast_d = libdivide_s32_gen(d);
        for (size_t i = 0; i < count; i++)
          result += libdivide_s32_do(numers[i], &fast_d);
        return result;
      }

      int main(void) {
        const int numers[] = {2, 4, 6, 8, 10};
        size_t count = sizeof(numers) / sizeof(int);
        int d = 2;
        int result = sum_of_quotients(numers, count, d);
        assert(result == 15);
        return 0;
      }
    C

    macro_suffix = Hardware::CPU.arm? ? "NEON" : "SSE2"
    ENV.append_to_cflags "-I#{include} -DLIBDIVIDE_#{macro_suffix}"

    system "make", "libdivide-test"
    system "./libdivide-test"
  end
end
