class Lnko < Formula
  desc "Simple stow-like dotfile linker"
  homepage "https://github.com/luanvil/lnko"
  url "https://github.com/luanvil/lnko/archive/refs/tags/v0.2.4.tar.gz"
  sha256 "575ff60b1d9c1557b8fb1a9e8f24a37342eb58f2e637b3a8b3221ad462110bf5"
  license "GPL-3.0-only"
  head "https://github.com/luanvil/lnko.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9aaebb073ac55959afac77b1205f4722e40ff0cc0ebdca03dcaab35b2ec8fd54"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "eb4166f201dd9dc64eadb578349720aa9a5688e95c41c3d4361ca587f1a2ebdf"
    sha256 cellar: :any,                 arm64_linux:   "4dd2a9cf00d7766ace8c81a82484947a97f1b9ccf85e48309a7db5b3247695a5"
    sha256 cellar: :any,                 x86_64_linux:  "e71593cd849494e01e516fb32a22148f62c55149ae905e58f22e66e94d23a95c"
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
