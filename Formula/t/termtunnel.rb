class Termtunnel < Formula
  desc "Cross-platform terminal tunnel tool"
  homepage "https://github.com/beordle/termtunnel"
  url "https://github.com/beordle/termtunnel/archive/refs/tags/version-1.7.4.tar.gz"
  sha256 "83973300ea77d9186376277032f8b979295e6fa1b47d830ea5bc7049af14a725"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e6271cc49bd07d846ce9011c682609734646f12cef0aa46b679c69f9d0e6c659"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "aa99e428f8f5a8d01a69812f3dc77ff146eb3758f258e88100b14c4bce3fe979"
    sha256 cellar: :any,                 arm64_linux:   "7f7bc6726415214d5fe27f95a9b87369f6a354263a0bb9341e3a6115487ad039"
    sha256 cellar: :any,                 x86_64_linux:  "f8669cfea29562566884ff62248b80c6e6ed91369cceffb4e039ae7a28fe6df4"
  end

  depends_on "cmake" => :build

  # because it vendors out the libuv source code
  conflicts_with "libuv", because: "both install `include/uv/darwin.h` file"

  deny_network_access!

  def install
    # CMake >= 3.25 defines LINUX, enabling a mixed plain/keyword `-static` link that fails to configure
    inreplace "CMakeLists.txt", 'target_link_libraries(termtunnel PUBLIC "-static")', ""
    # TODO: remove once upstream raises cmake_minimum_required for CMake 4
    system "cmake", "-S", ".", "-B", "build", "-DCMAKE_POLICY_VERSION_MINIMUM=3.5", *std_cmake_args
    system "cmake", "--build", "build"
    bin.install "build/termtunnel"
  end

  test do
    system bin/"termtunnel"
  end
end
