class Seamstress < Formula
  desc "Art engine and batteries-included Lua runtime"
  homepage "https://alanza.xyz/"
  url "https://github.com/robbielyman/seamstress/archive/refs/tags/v2.0.0-alpha+build.250109.tar.gz"
  version "2.0.0"
  sha256 "e61cda863afbf5c1555bbee35cdc5a3f0f8b1235451af2ac5a3a6e680eba4e02"
  license "MIT"

  depends_on "zig" => :build
  depends_on "busted" => :test

  def install
    # Fix illegal instruction errors when using bottles on older CPUs.
    # https://github.com/Homebrew/homebrew-core/issues/92282
    cpu = case Hardware.oldest_cpu
    when :arm_vortex_tempest then "apple_m1" # See `zig targets`.
    else Hardware.oldest_cpu
    end

    args = %W[
      --prefix #{prefix}
      -Doptimize=ReleaseSafe
    ]

    args << "-Dcpu=#{cpu}" if build.bottle?
    system "zig", "build", *args
  end

  test do
    # error enabling logging! FileNotFound\nlogging disabled!
    return if OS.linux? && ENV["HOMEBREW_GITHUB_ACTIONS"]

    lua_path_1 = "#{Formula["busted"].libexec}/share/lua/5.4/?/?.lua"
    lua_path_2 = "#{Formula["busted"].libexec}/share/lua/5.4/?.lua"
    lua_path_3 = "#{Formula["busted"].libexec}/share/lua/5.4/?/init.lua"
    with_env(
      "LUA_PATH"  => "#{lua_path_1};#{lua_path_2};#{lua_path_3}",
      "LUA_CPATH" => "#{Formula["busted"].libexec}/lib/lua/5.4/?.so",
    ) do
      assert_includes shell_output("#{bin}/seamstress --test"), "0 failures / 0 errors"
    end
  end
end
