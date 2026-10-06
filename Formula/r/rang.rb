class Rang < Formula
  desc "Minimal, Header only Modern c++ library for terminal goodies"
  homepage "https://agauniyal.github.io/rang/"
  url "https://github.com/agauniyal/rang/archive/refs/tags/v3.2.tar.gz"
  sha256 "8b42d9c33a6529a6c283a4f4c73c26326561ccc67fbb3e6a3225edd688b39973"
  license "Unlicense"

  livecheck do
    skip "no rencet releases"
  end

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    rebuild 1
    sha256 cellar: :any_skip_relocation, all: "c383da175e3075381f08ca5d80c6778962a7811f32162a8559b9a7e9c51a7922"
  end

  depends_on "cmake" => :build

  deny_network_access!

  def install
    # TODO: Remove when https://github.com/agauniyal/rang/pull/141 is released
    system "cmake", "-S", ".", "-B", "build", "-DCMAKE_POLICY_VERSION_MINIMUM=3.5", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include <rang.hpp>
      #include <iostream>

      int main() {
        std::cout << rang::style::bold << "Hello, world!" << rang::style::reset << std::endl;
        return 0;
      }
    EOS

    system ENV.cxx, "-std=c++11", "test.cpp", "-o", "test"
    assert_match "Hello, world!", shell_output("./test")
  end
end
