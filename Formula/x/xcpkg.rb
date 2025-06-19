class Xcpkg < Formula
  desc "Package builder for Xcode projects in C, C++, Rust, Zig, Go, Haskell, etc"
  homepage "https://github.com/leleliu008/xcpkg"
  url "https://github.com/leleliu008/xcpkg/archive/8599dc091052448d016831055bd96d958120772f.tar.gz"
  version "0.30.0"
  sha256 "69ed7002aa49d9ece103c54f7483ab010bf33aceb5e6a98ab32728b2cbd87434"
  license "Apache-2.0"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any, arm64_sequoia: "0970a19468329f62e8190c64e89a2612a0d4ac165ce191499bb7c32bba2ae3b2"
    sha256 cellar: :any, arm64_sonoma:  "fd0b4d32bfbb712d8cc014c886ece29477c3ec93d6d153362e4b371f24c602ae"
    sha256 cellar: :any, ventura:       "4d5284d977d565e3404e895780d73f15bf13f4e15f95dfd8dfb476e064a1bc27"
  end

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
