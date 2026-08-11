class Lnko < Formula
  desc "Simple stow-like dotfile linker"
  homepage "https://github.com/luanvil/lnko"
  url "https://github.com/luanvil/lnko/archive/refs/tags/v0.2.4.tar.gz"
  sha256 "575ff60b1d9c1557b8fb1a9e8f24a37342eb58f2e637b3a8b3221ad462110bf5"
  license "GPL-3.0-only"
  head "https://github.com/luanvil/lnko.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "95471fec274b1378f0f8cb73a211747640b834f70e96ca8b679441953e4cf6da"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d5e1077fe29a4aab1e78ce0283477ab01c3d19e7314bb26b383f1a2e1eeeb709"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ea55c1dd96c7ff5b3fe043ed9e7a84f5c4226e61e0dee381b7ae21ed1730a213"
    sha256 cellar: :any,                 arm64_linux:   "d58e93362f3b11f159a869fa8aea5a3b18bc4f505a37925e3521a5a168549ac5"
    sha256 cellar: :any,                 x86_64_linux:  "c94a9ea1a1daafd0b39b5095d7544faec221025466610870f38d90ac1ac20306"
  end

  depends_on "lua@5.4"

  resource "luafilesystem" do
    url "https://github.com/lunarmodules/luafilesystem/archive/refs/tags/v1_8_0.tar.gz"
    sha256 "16d17c788b8093f2047325343f5e9b74cccb1ea96001e45914a58bbae8932495"
  end

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
