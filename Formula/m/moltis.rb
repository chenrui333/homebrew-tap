class Moltis < Formula
  desc "Local-first personal AI gateway with plugin-driven channels"
  homepage "https://moltis.org/"
  url "https://github.com/moltis-org/moltis/archive/refs/tags/v0.10.17.tar.gz"
  sha256 "65cc0af6bcd2b70df0669eb76843519f74ba813be348c639899047e1c2178dd5"
  license "MIT"
  head "https://github.com/moltis-org/moltis.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "35b51f1f85d3deeede17f1600d0e27bfc4aa7f5a2bbff5dcedeb7f805cc73f6f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bc36ed1f91365e43b1a27d81cd736fb80a618edfff1066e9f3465551f34bbb24"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "cea14ef8109c281a7807e4951815edcc2bf8a4fbed82de2b1b012f79b7f718bc"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3671177547bdcc170f2e84dd45fe681fd66dfa7b8824f9f4ef1867144939995e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b63b4ab91259d18ec5c4ed774fcf54dd359c536200c8099df5323b6c9e64a675"
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
