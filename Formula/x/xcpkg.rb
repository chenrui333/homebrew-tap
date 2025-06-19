class Xcpkg < Formula
  desc "Package builder for Xcode projects in C, C++, Rust, Zig, Go, Haskell, etc"
  homepage "https://github.com/leleliu008/xcpkg"
  url "https://github.com/leleliu008/xcpkg/archive/8599dc091052448d016831055bd96d958120772f.tar.gz"
  version "0.30.0"
  sha256 "69ed7002aa49d9ece103c54f7483ab010bf33aceb5e6a98ab32728b2cbd87434"
  license "Apache-2.0"

  depends_on "cmake" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build

  depends_on "curl"
  depends_on "jansson"
  depends_on "libarchive"
  depends_on "libgit2"
  depends_on "libyaml"
  depends_on :macos
  depends_on "openssl@3"

  def install
    system "cmake", "-S", "c", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/xcpkg --version")
    assert_match "sysinfo.ncpu", shell_output("#{bin}/xcpkg sysinfo")
  end
end
