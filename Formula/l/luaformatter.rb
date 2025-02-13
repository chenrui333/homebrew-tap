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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0e3af9166259de713eea2fe893af1569e856e47b92a3326f08b5ee1dbf62e651"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fab0596fc1240d3f0913a233365a79bca960d43781f2726c2eac5b3d362d565e"
    sha256 cellar: :any_skip_relocation, ventura:       "6d133aca7d7261a079428d8679c477d66f3efbd38ad9f8fb72b43d382a896fbc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "343d3e2c37d34fed41cee112308fe21c580593240de9ad32f05b5e4df791a39a"
  end

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
