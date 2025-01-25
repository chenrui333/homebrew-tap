class Termtunnel < Formula
  desc "Cross-platform terminal tunnel tool"
  homepage "https://github.com/beordle/termtunnel"
  url "https://github.com/beordle/termtunnel/archive/refs/tags/version-1.7.4.tar.gz"
  sha256 "83973300ea77d9186376277032f8b979295e6fa1b47d830ea5bc7049af14a725"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "176466d11de604e1f1c9cbf8af6279eadf8048bff450deacc8230f85c77c98fd"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d9c57e336071d8f5064e657050b02dfef217de9cb4ed2b95c9d423a9afb9a1eb"
    sha256 cellar: :any_skip_relocation, ventura:       "b1aefe6fe9722400f6927c6cf0c99f1d883248459e9e550d1d827a1acae3a6fb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7c0b0c21fb673cb4939e18b2ac07af846345b0e59b9cfe6dd66ce08bd73d3436"
  end

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
