class Moltis < Formula
  desc "Local-first personal AI gateway with plugin-driven channels"
  homepage "https://moltis.org/"
  url "https://github.com/moltis-org/moltis/archive/refs/tags/v0.9.3.tar.gz"
  sha256 "51cd6068bf1ed9a20377578f9254fb3a33377da09bcd15489a26e33463310948"
  license "MIT"
  head "https://github.com/moltis-org/moltis.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9d4fded7f6b7334c85f9bc7513d77c7329ae54d307377f3cf13c6100b6dc9fab"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "509805fa8669146f776a17f7481c39484f416e3aac0c653c76a6aaba495414d8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2cbb543fa7c1d3b21119b5a12e3cf337dff2c01bbd714e86144a654bbea5cb46"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "600aa2f84aabfa41088dab93d4d35feaaad36829262b90620f72b1e82025da02"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3da1d84929d04e245e0d642b886ad23b3fbbf1f40cd2b80379b4b67b70f9800b"
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
    ENV["HOME"] = testpath

    assert_match version.to_s, shell_output("#{bin}/moltis --version")
    assert_match "No issues found.", shell_output("#{bin}/moltis config check 2>&1")
  end
end
