class Lnko < Formula
  desc "Simple stow-like dotfile linker"
  homepage "https://github.com/luanvil/lnko"
  url "https://github.com/luanvil/lnko/archive/refs/tags/v0.6.0.tar.gz"
  sha256 "6842ce5254761e1f350aa4b834d7cf71d210f54d036151ec42d1aedb0adcbc69"
  license "GPL-3.0-only"
  head "https://github.com/luanvil/lnko.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "cc8c2e106d7478061d0afe8bd979ebe9a4473976e627a6c48365d08ad3100daf"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "61a9b02b5e84a367cd6e965efc92ba40e61e6bed67d686bd57ea3d833efce149"
    sha256 cellar: :any,                 arm64_linux:   "b9cbe2f6769da16495a9f5424394057c824745a204f752a1cdc88e228558deb3"
    sha256 cellar: :any,                 x86_64_linux:  "b50b62e4b793b6ff662b4f4c42e463cc7b12578bcc576c96b45a0c25f86fe736"
  end

  depends_on "lua@5.4"

  resource "luafilesystem" do
    url "https://github.com/lunarmodules/luafilesystem/archive/refs/tags/v1_8_0.tar.gz"
    sha256 "16d17c788b8093f2047325343f5e9b74cccb1ea96001e45914a58bbae8932495"
  end

  deny_network_access!

  def install
    lua = Formula["lua@5.4"]
    lua_version = lua.version.major_minor
    lua_include = lua.opt_include
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
      exec "#{lua.opt_bin}/lua" "#{libexec}/bin/lnko.lua" "$@"
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
