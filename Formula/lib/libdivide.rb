class Libdivide < Formula
  desc "Optimized integer division"
  homepage "https://libdivide.com"
  url "https://github.com/ridiculousfish/libdivide/archive/refs/tags/v5.2.0.tar.gz"
  sha256 "73ae910c4cdbda823b7df2c1e0e1e7427464ebc43fc770b1a30bb598cb703f49"
  license any_of: ["Zlib", "BSL-1.0"]
  head "https://github.com/ridiculousfish/libdivide.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ffea4910f7eb49c0df9d5b567a6c1923ee218e1676216caf98608e33d55507b5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d51f987325923def362f7469e1dfb59505a9cd4ac10fc3002ae5a9538512754d"
    sha256 cellar: :any_skip_relocation, ventura:       "1a6c0c352d1e58c3bc7f72a378ee73e84361d9c8a50e4ef304aec6b4ccd3e8df"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "57ac2f5016adfea40feb2e91c28a347d4919802770bbd2e56ade8d1275f9dcf8"
  end

  depends_on "cmake" => :build

  # include sanitisers for release build, upstream pr ref, https://github.com/ridiculousfish/libdivide/pull/129
  patch do
    url "https://github.com/ridiculousfish/libdivide/commit/41c04ea14b9c661e891ef35b122c5cce74837c8a.patch?full_index=1"
    sha256 "e431c9dd5163d1636dc53e689b33d27f38f9dce674532f8e1df1ff90ae112efc"
  end

  def install
    # Skip `cmake --build`, as this is only for building tests.
    system "cmake", "-S", ".", "-B", "build", "-DLIBDIVIDE_BUILD_TESTS=OFF", *std_cmake_args
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"libdivide-test.c").write <<~C
      #include "libdivide.h"
      #include <assert.h>

      int sum_of_quotients(const int *numbers, size_t count, int d) {
        int result = 0;
        struct libdivide_s32_t fast_d = libdivide_s32_gen(d);
        for (size_t i = 0; i < count; i++)
          result += libdivide_s32_do(numbers[i], &fast_d);
        return result;
      }

      int main(void) {
        const int numbers[] = {2, 4, 6, 8, 10};
        size_t count = sizeof(numbers) / sizeof(int);
        int d = 2;
        int result = sum_of_quotients(numbers, count, d);
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
