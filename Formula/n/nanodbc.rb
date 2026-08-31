class Nanodbc < Formula
  desc "Small C++ wrapper for the native C ODBC API"
  homepage "https://nanodbc.github.io/nanodbc/"
  url "https://github.com/nanodbc/nanodbc/archive/refs/tags/v3.0.2.tar.gz"
  sha256 "2a0ff611c625083c97f7327f67f230f58966ecf841e9139e740b7f303b0aa00b"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any,                 arm64_sequoia: "3627ff1858f01199dd5e236230c4069c942ccc66a0462490824342af9dedc309"
    sha256 cellar: :any,                 arm64_sonoma:  "1d7862fbf0d36102f2e3b848ecd14c5e5458846f45a666b7d83ed9f54fbeff57"
    sha256 cellar: :any,                 ventura:       "3cc39fc8c85feb5d2f56e235d833a7b53f6f1b41020ff5618c8db7c4d61d33dc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4faccb446d3585c91a3093817cca08f2b97c3b162237fad43f0fe2e0b1153377"
  end

  depends_on "cmake" => :build

  on_macos do
    depends_on "libiodbc"
  end

  on_linux do
    depends_on "unixodbc"
  end

  def install
    args = %w[
      -DNANODBC_BUILD_EXAMPLES=OFF
      -DNANODBC_BUILD_TESTS=OFF
      -DBUILD_SHARED_LIBS=ON
      -DCMAKE_POLICY_VERSION_MINIMUM=3.5
    ]

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include <nanodbc/nanodbc.h>
      int main() {
        nanodbc::string sql = NANODBC_TEXT("SELECT 1");
        return 0;
      }
    EOS
    system ENV.cxx, "test.cpp", "-std=c++17", "-o", "test", "-I#{include}", "-L#{lib}",
                    "-Wl,-rpath,#{lib}", "-lnanodbc"
    system "./test"
  end
end
