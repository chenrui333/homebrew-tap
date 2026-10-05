class Luaformatter < Formula
  desc "Code formatter for Lua"
  homepage "https://github.com/Koihik/LuaFormatter"
  url "https://github.com/Koihik/LuaFormatter.git",
      tag:      "1.3.6",
      revision: "417d4570a4265109ebbab6610023e91c4668f631"
  license "Apache-2.0"
  head "https://github.com/Koihik/LuaFormatter.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d0339cb54213d41a7268e649d8c84d7f0e8b27bb5ed4cf839ed33685fbe280bc"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "26c4a238a2d77b8fae6d635d6465778e2c3dcd56d43e7e7b2ed55f2bdac3f91a"
    sha256 cellar: :any,                 arm64_linux:   "65b36b0695370b3d23147697bce103ffbfc12e7fd10520d77413f0fc1bcac2a8"
    sha256 cellar: :any,                 x86_64_linux:  "6f8431a683788778b9a76a14f9e31c7a25da39f4160a2f8eb4328e16121564c4"
  end

  depends_on "cmake" => :build

  deny_network_access!

  def install
    args = %w[
      -DBUILD_TESTS=OFF
      -DCOVERAGE=OFF
    ]
    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    # Stop the upward `.lua-format` search before it lists sandbox-unreadable `/`.
    (testpath/".lua-format").write "column_limit: 80\n"

    (testpath/"test.lua").write <<~LUA
      function test()
      print("Hello, World!")
      end
    LUA

    # Non-zero return if formatting is needed
    system bin/"lua-format", "test.lua"

    system bin/"lua-format", "--in-place", "test.lua"
    formatted_content = (testpath/"test.lua").read
    expected_content = <<~LUA
      function test() print("Hello, World!") end
    LUA

    assert_equal expected_content, formatted_content
  end
end
