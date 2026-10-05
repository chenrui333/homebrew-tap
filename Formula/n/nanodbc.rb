class Nanodbc < Formula
  desc "Small C++ wrapper for the native C ODBC API"
  homepage "https://nanodbc.github.io/nanodbc/"
  url "https://github.com/nanodbc/nanodbc/archive/refs/tags/v3.0.5.tar.gz"
  sha256 "b3c8730376c4f0f6329dc4664efc1ccbc8861922fcdc5891d5a4591f8fde69b0"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    rebuild 1
    sha256 cellar: :any, arm64_tahoe:   "f3cdd906ff05a478b9c95701cb1c6a35ee9e68cb1176da701f364e4495724eb9"
    sha256 cellar: :any, arm64_sequoia: "dd3c42e86443a0e482469fe46dd702c5e3a160c5bbbb152fcdc17583ff63b202"
    sha256 cellar: :any, arm64_linux:   "74e8b7351b3acb125953a23553a7eb85fe11985ff861d04fc64a2b9324636a2b"
    sha256 cellar: :any, x86_64_linux:  "f603aca85d1bcb41e9c923b63b22697a03ec5f56495db1c5415822371ce3b6e8"
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
