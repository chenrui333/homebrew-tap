class Moltis < Formula
  desc "Local-first personal AI gateway with plugin-driven channels"
  homepage "https://moltis.org/"
  url "https://github.com/moltis-org/moltis/archive/refs/tags/v0.10.11.tar.gz"
  sha256 "2ef125f763c2a06b156cafe015098a881b93e366b63157bea23bdb39059c5d54"
  license "MIT"
  head "https://github.com/moltis-org/moltis.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "06d617c9427cff0b730a19a088b6a2a34a7cba95463d2e7a77709920cbbaeaa4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d9b6c842a1f6ed9f196127b2e5b7d4fcd958d4e3fd4a120f23b1fd4b16705c3b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0aeffc1bc2bd2ddd3cbea547252f3e4c86319f9b3d9a715eee02c934f0786018"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6c2164a3e9daf3559837b7e008ad4486086a51c16769131d3e567e2be5f620ab"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9722a537e9e81bdbfdc71dfbb33a162c4d55556cf766ea85b2ea4ed51cc14c07"
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
