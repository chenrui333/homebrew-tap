class Moltis < Formula
  desc "Local-first personal AI gateway with plugin-driven channels"
  homepage "https://moltis.org/"
  url "https://github.com/moltis-org/moltis/archive/refs/tags/v0.10.18.tar.gz"
  sha256 "93ba8daee48bfd3a3782144a5d816ead7b9e2adac6b5a975f60e0fb69380f8ff"
  license "MIT"
  head "https://github.com/moltis-org/moltis.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b8c56529d6991c58d0b3938be92a5f492e95526c10fdd8cbbf47ee9c20a84723"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a7d44b10539dd1d02d0e75660982c5ed1797b24edf92eab7ded787378061288d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e3cdb148bb90de7f90d759134a361550595ab17217881d49d3c39d30ec71b5ca"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5b4ab12e751fbe1e66f25d44e714276c3cf054c213e64334fc6fc2d0b1ff742c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b75a699b843e6971d21ae4f5c1b70ca4daba8c6c9080e43e243f9c9027ee1045"
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
    ENV["RUSTC_BOOTSTRAP"] = "1"
    # Avoid compiling embedded WASM tools on unsupported build targets.
    inreplace "Cargo.toml",
      'moltis-tools           = { path = "crates/tools" }',
      'moltis-tools           = { default-features = false, path = "crates/tools" }'

    if OS.linux?
      zlib = Formula["zlib-ng-compat"]
      ENV["LIBCLANG_PATH"] = Formula["llvm"].opt_lib.to_s
      ENV["ZLIB_ROOT"] = zlib.opt_prefix.to_s
      ENV.append_path "PKG_CONFIG_PATH", zlib.opt_lib/"pkgconfig"
      ENV.append "LDFLAGS", "-L#{zlib.opt_lib}"
      ENV.append "CPPFLAGS", "-I#{zlib.opt_include}"
    end

    system "cargo", "install", "--no-default-features", "--features", "lightweight",
      *std_cargo_args(path: "crates/cli")
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
