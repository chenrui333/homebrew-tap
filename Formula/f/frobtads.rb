class Frobtads < Formula
  desc "TADS interpreter and compilers"
  homepage "https://www.tads.org/frobtads.htm"
  url "https://github.com/realnc/frobtads/releases/download/v2.0/frobtads-2.0.tar.bz2"
  sha256 "893bd3fd77dfdc8bfe8a96e8d7bfac693da0e4278871f10fe7faa59cc239a090"
  license :cannot_represent

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 arm64_tahoe:   "1eefd8637bd7b1e3dad8a1782607edbf50ebf96e2e9dc49f498d3b260ea1efd0"
    sha256 arm64_sequoia: "8a33912d060368654d777176910ad260e92bf96679b817c37c999760e6d42c77"
    sha256 arm64_sonoma:  "0545070021fa9ba1b203c9bc7f3eca50a3c188872cec51856f01e9635703f67a"
    sha256 sequoia:       "ef1d0470faf37d3a21e8fe9a23156eab5fcfe59666a2d611d894a3e582bb8948"
    sha256 arm64_linux:   "49ec1a949da8dbc3ccbd695939e4774e5913505bc8a7a9e4b97f43f2193184ef"
    sha256 x86_64_linux:  "8dcdbc5d39ca1fe5cfab652c0aa660aff1e2e59748fc982b7333bc6a9a832023"
  end

  depends_on "cmake" => :build

  uses_from_macos "curl"
  uses_from_macos "ncurses"

  def install
    system "cmake", "-S", ".", "-B", "build", "-DCMAKE_POLICY_VERSION_MINIMUM=3.5", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"hello.t").write <<~EOS
      #charset "us-ascii"
      #include <tads.h>

      main(args) {
        "Hello, Homebrew!";
      }
    EOS

    system bin/"t3make", "hello.t"
    system bin/"frob", "--no-pause", "hello.t3"

    assert_match version.to_s, shell_output("#{bin}/frob --version")
  end
end
