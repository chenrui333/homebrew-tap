class Moltis < Formula
  desc "Local-first personal AI gateway with plugin-driven channels"
  homepage "https://moltis.org/"
  url "https://github.com/moltis-org/moltis/archive/refs/tags/v0.9.5.tar.gz"
  sha256 "1230c7d4d991d09ea33c06f6a92312f7994aa4c9fe6c6f71fad775db81e398cc"
  license "MIT"
  head "https://github.com/moltis-org/moltis.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f456bfb5381cdc3e127fee6358f592a11f8d50326cf25cb587c398597f04a1d1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e17f604116f7c5d5a00328553fc108ec8fbac34a3e28a17ebc27a19ab2712d93"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d44443d49911b81d24a48be6d7fa35f0461309a5ee13eaacc065099811c77809"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1d537044e8d53384ce676ac0b0c657c591023f0e4219f271973818d6f0716757"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "973d5b3fd8a03690ca10db9a8345f142b630c66e4669cbaad27864cd21ac6626"
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
