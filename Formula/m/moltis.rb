class Moltis < Formula
  desc "Local-first personal AI gateway with plugin-driven channels"
  homepage "https://moltis.org/"
  url "https://github.com/moltis-org/moltis/archive/refs/tags/v0.9.1.tar.gz"
  sha256 "4744b598d83aa0d154ba45de1c74751437597cb80cb814d89f7f26967fd23896"
  license "MIT"
  head "https://github.com/moltis-org/moltis.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6330863cb4b616ddf5ca66e0136916e3c4a50f01f534ed1e1b804d05d2aa7469"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3efa038dc1c1d321355bd0f3b682dc652b9253ce7a44123a01f99a91f16d648e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a06f2307ebba5dec3761445c98c612e53d5b52ec82683540ad4136b746ddbcea"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b8719a1dbf4dc8025a8958f630e36be6d75ba55b38904880e60083424205e47c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5e1228c15d1c4072f628b351587cc67a0c53d3f60bae79578148cf886b45a421"
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
