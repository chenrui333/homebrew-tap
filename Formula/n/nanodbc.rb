class Nanodbc < Formula
  desc "Small C++ wrapper for the native C ODBC API"
  homepage "https://nanodbc.github.io/nanodbc/"
  url "https://github.com/nanodbc/nanodbc/archive/refs/tags/v3.0.3.tar.gz"
  sha256 "15e0602bc5be18a64e22992e354acb87d1a7af9c99b18c80192cc63cc75b5abe"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any, arm64_tahoe:   "6d517823be5a9150b775d456867b112a650edce5093223056f92018e37a5fde8"
    sha256 cellar: :any, arm64_sequoia: "83694fbf0e84417757654696b065c1dbaf50da92352e5fa1913e072adc96a05c"
    sha256 cellar: :any, arm64_linux:   "d1a47b9f55457abc29ebfde9d06b92152cb87a632ec1aad7a950577c6ae31b1d"
    sha256 cellar: :any, x86_64_linux:  "acb59022b77b497deabe89db78097b17e2df5883261238b8125d6004cb27acea"
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
