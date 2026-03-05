class Moltis < Formula
  desc "Local-first personal AI gateway with plugin-driven channels"
  homepage "https://moltis.org/"
  url "https://github.com/moltis-org/moltis/archive/refs/tags/v0.10.13.tar.gz"
  sha256 "fe2b9d8d46000a4deaa203180f52e4ff115e87f68e229d964f2573fdd5f0a0f2"
  license "MIT"
  head "https://github.com/moltis-org/moltis.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "07875d4f3b14259f8e27496e821815ab20f3ca0bf03f55e4da1f95c9c93b1144"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a0f36e0c6f7b8f90a86d264f678bb7bae4c7fc7d922848cc1b5992143f2c53a6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "94ba6010446314575ccf600f9e8309a53b49b353083617e2101c9ac1edac595d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8fccd6d092f8ce309370517f9e299efe9192030e398ad95319d128c5932fe430"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a4472cb4078ad356c1f2f84e05ff0e4b0f003b619ad24d082adf5c86bd2fa6aa"
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
