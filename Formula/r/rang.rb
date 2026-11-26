class Rang < Formula
  desc "Minimal, Header only Modern c++ library for terminal goodies"
  homepage "https://agauniyal.github.io/rang/"
  url "https://github.com/agauniyal/rang/archive/refs/tags/v3.3.tar.gz"
  sha256 "e835f79e71e1befb0b0c2906cfaa5cb07e12c6f88789931cd3c86c80c852453a"
  license "Unlicense"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    manifest_sha256 "cf4783a86872ba764e709bc708e2e52daa61125706c12195b7936dd715916519"
    sha256 cellar: :any_skip_relocation, all: "59815047794065286b849216f7ce8e3bf1ae96b2fd287893d5a89b7ff55be454"
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
