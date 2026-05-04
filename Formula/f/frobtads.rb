class Frobtads < Formula
  desc "TADS interpreter and compilers"
  homepage "https://www.tads.org/frobtads.htm"
  url "https://github.com/realnc/frobtads/releases/download/v2.0/frobtads-2.0.tar.bz2"
  sha256 "893bd3fd77dfdc8bfe8a96e8d7bfac693da0e4278871f10fe7faa59cc239a090"
  license :cannot_represent

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
