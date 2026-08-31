class Nanodbc < Formula
  desc "Small C++ wrapper for the native C ODBC API"
  homepage "https://nanodbc.github.io/nanodbc/"
  url "https://github.com/nanodbc/nanodbc/archive/refs/tags/v3.0.2.tar.gz"
  sha256 "2a0ff611c625083c97f7327f67f230f58966ecf841e9139e740b7f303b0aa00b"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any, arm64_tahoe:   "7f062bbb000249aa65d4ff02ad9c454168d10b3176f72d11cd4289a8cfa8e807"
    sha256 cellar: :any, arm64_sequoia: "699cbf912418a667a2fc3322c562fef5f91f441517c21f49e9829c2415a6b2a6"
    sha256 cellar: :any, arm64_sonoma:  "5ad19f0a5322a3c08891143349b49097da0c67e74af2383f4599461e3c88e42f"
    sha256 cellar: :any, arm64_linux:   "7dad8ff1f66c7cf481035d4897fbf74f88435bbe26f0e0d92eab429b2a2b3ec7"
    sha256 cellar: :any, x86_64_linux:  "d05f64d641901278ac85acf425bb05d76b70946ea4cf85c07c921a04b0dbf956"
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
