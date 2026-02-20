class Moltis < Formula
  desc "Local-first personal AI gateway with plugin-driven channels"
  homepage "https://moltis.org/"
  url "https://github.com/moltis-org/moltis/archive/refs/tags/v0.9.7.tar.gz"
  sha256 "93b20a1199dde24ccd1fa376282d270ff1df54382b11adb9745d601ceda743e1"
  license "MIT"
  head "https://github.com/moltis-org/moltis.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d756065e41db4d01e3089d342ac714fe6e30a8ca5318d407148a9a5f7ca46945"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fef90b8af04351694e2225718c466d69535f4a05ee6ff5d25c41e080909561a9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2903d7781950b0d99bee86ab4724ba06dda58daf1a874085aea2440c3d582bc7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "175abcc7e5afdaadf534195882fb6aa465d31149358ba6633df3912ab20aae6c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2e4bcd79670fde94f1df625ab190a12370a15a0323c243f9452110bce66f9225"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "openssl@3"

  on_linux do
    depends_on "llvm" => :build
    depends_on "zlib-ng-compat"
  end

  def install
    if OS.linux?
      zlib = Formula["zlib-ng-compat"]
      ENV["LIBCLANG_PATH"] = Formula["llvm"].opt_lib.to_s
      ENV["ZLIB_ROOT"] = zlib.opt_prefix.to_s
      ENV.append_path "PKG_CONFIG_PATH", zlib.opt_lib/"pkgconfig"
      ENV.append "LDFLAGS", "-L#{zlib.opt_lib}"
      ENV.append "CPPFLAGS", "-I#{zlib.opt_include}"
    end

    system "cargo", "install", *std_cargo_args(path: "crates/cli")
  end

  service do
    run [opt_bin/"moltis", "gateway"]
    keep_alive true
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/moltis --version")
    assert_match "No issues found.", shell_output("#{bin}/moltis config check 2>&1")
  end
end
