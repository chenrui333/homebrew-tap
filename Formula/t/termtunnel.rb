class Termtunnel < Formula
  desc "Cross-platform terminal tunnel tool"
  homepage "https://github.com/beordle/termtunnel"
  url "https://github.com/beordle/termtunnel/archive/refs/tags/version-1.7.4.tar.gz"
  sha256 "83973300ea77d9186376277032f8b979295e6fa1b47d830ea5bc7049af14a725"
  license "MIT"

  depends_on "cmake" => :build

  # because it vendors out the libuv source code
  conflicts_with "libuv", because: "both install `include/uv/darwin.h` file"

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    bin.install "build/termtunnel"
  end

  test do
    system bin/"termtunnel"
  end
end
