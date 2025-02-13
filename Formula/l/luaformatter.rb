class Luaformatter < Formula
  desc "Code formatter for Lua"
  homepage "https://github.com/Koihik/LuaFormatter"
  url "https://github.com/Koihik/LuaFormatter.git",
      tag:      "1.3.6",
      revision: "417d4570a4265109ebbab6610023e91c4668f631"
  license "Apache-2.0"
  head "https://github.com/Koihik/LuaFormatter.git", branch: "master"

  depends_on "cmake" => :build

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
