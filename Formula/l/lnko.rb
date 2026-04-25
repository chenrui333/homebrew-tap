class Lnko < Formula
  desc "Simple stow-like dotfile linker"
  homepage "https://github.com/luanvil/lnko"
  url "https://github.com/luanvil/lnko/archive/refs/tags/v0.2.3.tar.gz"
  sha256 "4eabc70767cd5cedd365113b81618d61566c10cbf3a7e8d15729d9a005cf641c"
  license "GPL-3.0-only"
  head "https://github.com/luanvil/lnko.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d4da7bbbce232b1f890e6727a1dafaff27bca6b4356fc0c7ab310a256dc93061"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e99f8b263b34cac0c4ba4611d0dab8acd21903851d2861d47df01d1e407528f8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8204e0d2e89cc987ac5c158385ae4363990dd4cad757da23618d66e748724655"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b60067eb6cc81c0c391309da891191e7599a120bbb618032f0c8c86a055b7fa9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a03baa78ebe8f36487583dd15034e85aafbef4ca5a27d24919ece316f9d07997"
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
