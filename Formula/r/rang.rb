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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "dc51e87d0046034c644a86254247f57234975fa10b793d09d50af1b1995bc62c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "cb27d5603710a5b78a9427887243c9ecd320a928fab5cd0e1b76374ad32f5c57"
    sha256 cellar: :any_skip_relocation, ventura:       "4c1a641de098889523d3830c61d8e1780d6674b57607806230f165d2549d8f43"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "010f3396387c58cb799dc6359c134dee5955095dfad80649703658919a6b9f39"
  end

  depends_on "cmake" => :build

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
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
