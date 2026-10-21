class Nanodbc < Formula
  desc "Small C++ wrapper for the native C ODBC API"
  homepage "https://nanodbc.github.io/nanodbc/"
  url "https://github.com/nanodbc/nanodbc/archive/refs/tags/v3.0.8.tar.gz"
  sha256 "bbb8ec400f0f84a7f6d61d4a4360e4c90eece6add3735e6b0b451ab90ca76f3e"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any, arm64_tahoe:   "46bb0ff28a96ff221deb572ec353ee5cf18a3b92b08e6cbd5be683a4ebdbaf6e"
    sha256 cellar: :any, arm64_sequoia: "ba20c2b205211ea971e57d0701ebd1c70539f6bfcaec6c8b8e9b823281fc4a4d"
    sha256 cellar: :any, arm64_linux:   "a640f7b9b96960dcfc4ff7ca64cec904661964284b09c820bcc079a71bafd93a"
    sha256 cellar: :any, x86_64_linux:  "af4b4e7733bf8d5df904d0c0d0358bd176d3fdf7533798701490b4c8d287ae19"
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
