class Moltis < Formula
  desc "Local-first personal AI gateway with plugin-driven channels"
  homepage "https://moltis.org/"
  url "https://github.com/moltis-org/moltis/archive/refs/tags/v0.10.16.tar.gz"
  sha256 "5a31a974ba9888cb8416fd0e3594ffdf5c2c8588c763fda5d69801b9eb5ff073"
  license "MIT"
  head "https://github.com/moltis-org/moltis.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5c4dce7d49992c85f811821c1b3043dc7ec9f503ba72a9f982976e2692c09a86"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "527798753caa2c1c00f9f9f1763dd6a123dd35442cd77275da2566d137893cb7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e063e0e32f1adc16492ae50c316224fc1d7c41969f00a18d52888667fd0b9f49"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "25f2c1b2cfc8e54986b6fb8773dd7b76647ffa5d2c457339734cc5516ef0d934"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4e8f850da05d98144882ebfc06d08ec16d8f73f4011ef45f46eec9d4a3b3ca33"
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
