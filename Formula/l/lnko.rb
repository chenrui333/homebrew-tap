class Lnko < Formula
  desc "Simple stow-like dotfile linker"
  homepage "https://github.com/luanvil/lnko"
  url "https://github.com/luanvil/lnko/archive/refs/tags/v0.2.2.tar.gz"
  sha256 "cb88089bc789d38754648244f8e1cb7aa901479c40e57069e1a214ec5334dd17"
  license "GPL-3.0-only"
  head "https://github.com/luanvil/lnko.git", branch: "main"

  depends_on "lua"

  resource "luafilesystem" do
    url "https://github.com/lunarmodules/luafilesystem/archive/refs/tags/v1_8_0.tar.gz"
    sha256 "16d17c788b8093f2047325343f5e9b74cccb1ea96001e45914a58bbae8932495"
  end

  def install
    lua_version = Formula["lua"].version.major_minor
    lua_include = Formula["lua"].opt_include
    lua_libdir = libexec/"lib/lua/#{lua_version}"

    resource("luafilesystem").stage do
      lib_option =
        if OS.mac?
          "-bundle -undefined dynamic_lookup"
        else
          "-shared"
        end

      system "make",
             "CC=#{ENV.cc}",
             "LIB_OPTION=#{lib_option}",
             "LUA_VERSION=#{lua_version}",
             "LUA_LIBDIR=#{lua_libdir}",
             "LUA_INC=-I#{lua_include}/lua -I#{lua_include}/lua#{lua_version}"
      system "make", "install", "LUA_LIBDIR=#{lua_libdir}", "DESTDIR="
    end

    libexec.install "lnko"
    (libexec/"bin").install "bin/lnko.lua"

    (bin/"lnko").write <<~SH
      #!/bin/bash
      export LUA_PATH="#{libexec}/?.lua;#{libexec}/?/init.lua;#{libexec}/lnko/?.lua;;"
      export LUA_CPATH="#{lua_libdir}/?.so;;"
      exec "#{Formula["lua"].opt_bin}/lua" "#{libexec}/bin/lnko.lua" "$@"
    SH
  end

  test do
    source = testpath/"dotfiles"
    (source/"pkg").mkpath
    (source/"pkg/.vimrc").write "set number\n"
    target = testpath/"target"
    target.mkpath

    system bin/"lnko", "link", "--dir", source, "--target", target, "pkg"
    assert_predicate target/".vimrc", :symlink?
    assert_equal "set number\n", (target/".vimrc").read
  end
end
