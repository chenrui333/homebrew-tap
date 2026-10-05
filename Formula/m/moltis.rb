class Moltis < Formula
  desc "Local-first personal AI gateway with plugin-driven channels"
  homepage "https://moltis.org/"
  url "https://github.com/moltis-org/moltis/archive/refs/tags/v0.10.18.tar.gz"
  sha256 "93ba8daee48bfd3a3782144a5d816ead7b9e2adac6b5a975f60e0fb69380f8ff"
  license "MIT"
  head "https://github.com/moltis-org/moltis.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a4de1626e91feba5642eee224e049746a87d6cdbb7eb50b05beee6f0b8962453"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "971347e3ff1b5da27aef6f4ffff3458302b762b86954421da3da80f0657cea89"
    sha256 cellar: :any,                 arm64_linux:   "157ab473fd9169a8ab6a1ae453a0adc58dd2555511b61d531d0e7a022ee25e3e"
    sha256 cellar: :any,                 x86_64_linux:  "cb1523725011ca3693e813bb0c8053a8247ad3d7ae3886a97a5366fa24becf75"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "openssl@3"

  on_linux do
    depends_on "llvm" => :build
    depends_on "zlib-ng-compat"
  end

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    ENV["RUSTC_BOOTSTRAP"] = "1"
    # Avoid compiling embedded WASM tools on unsupported build targets.
    inreplace "Cargo.toml",
      'moltis-tools           = { path = "crates/tools" }',
      'moltis-tools           = { default-features = false, path = "crates/tools" }'

    if OS.linux?
      zlib = Formula["zlib-ng-compat"]
      ENV["LIBCLANG_PATH"] = formula_opt_lib("llvm").to_s
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
