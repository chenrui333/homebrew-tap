class Nanodbc < Formula
  desc "Small C++ wrapper for the native C ODBC API"
  homepage "https://nanodbc.github.io/nanodbc/"
  url "https://github.com/nanodbc/nanodbc/archive/refs/tags/v3.0.7.tar.gz"
  sha256 "9c1b201f009cd633c81a463c3ff8ec79081921f50c56c926621262c689b77663"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any, arm64_tahoe:   "c332df607d95e45c07bff5c865bc3a370f5c5a8a4b6479dd901ca29cab117a5d"
    sha256 cellar: :any, arm64_sequoia: "b3efa5ae1d2e02a86ac58a3c4c3056dedeeff40c4401ee2764b03e34f9f3e6d5"
    sha256 cellar: :any, arm64_linux:   "8277cd0977a57a6f532e13b312e7a81edd686b5e67bfca925ddd48c76f4b3ff2"
    sha256 cellar: :any, x86_64_linux:  "3b7d3e6d6c2b31c6fac8c164ba98681cbd5f5372025a66234a334eb27db1063a"
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
