class Moltis < Formula
  desc "Local-first personal AI gateway with plugin-driven channels"
  homepage "https://moltis.org/"
  url "https://github.com/moltis-org/moltis/archive/refs/tags/v0.10.14.tar.gz"
  sha256 "333667e9bab3e00bcb92fbfded4d00fe7aaabf3db9f64320c06556ca1965f296"
  license "MIT"
  head "https://github.com/moltis-org/moltis.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ffd8e8faebf86c4852e75a5183cb9d489c8422cbb1e78f9b4e2ef992e209e344"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8381ee6d636bf2369f3ab5dcf7c5f896ef9a0b0d818c6bcbb8664da51a1af698"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6d8535772bace3840998c2572c1948e380a76aa00b21dac8858f7231e856a65f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f394ad07e4b09fd8a6f3f8e2d3d35f38397e4bf23888ea25cd6b36fd57edb598"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "daff63200c1fbc426d84e8a6a7710923bd9acf22685c8646955adaefd807e36a"
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
