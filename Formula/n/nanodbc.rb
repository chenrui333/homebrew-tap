class Nanodbc < Formula
  desc "Small C++ wrapper for the native C ODBC API"
  homepage "https://nanodbc.github.io/nanodbc/"
  url "https://github.com/nanodbc/nanodbc/archive/refs/tags/v3.0.5.tar.gz"
  sha256 "b3c8730376c4f0f6329dc4664efc1ccbc8861922fcdc5891d5a4591f8fde69b0"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any, arm64_tahoe:   "d4b2dd74cec00984029026ef86a2a842ed83e0d9601143e4d9607f31b36b70a7"
    sha256 cellar: :any, arm64_sequoia: "4c168e96568016b26bb0c35811bbf4d23d9aa671f81dab78d5fa77ced74704b9"
    sha256 cellar: :any, arm64_linux:   "5a3e152dd26513697495004df351c43dd6a824e823d6cdf616c4d4d53e3a9345"
    sha256 cellar: :any, x86_64_linux:  "3fb4f3ee15e3239c07169813815f99ad00b5a11bbe87482495442c4a710d87c8"
  end

  depends_on "cmake" => :build

  on_macos do
    depends_on "libiodbc"
  end

  on_linux do
    depends_on "unixodbc"
  end

  deny_network_access!

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
