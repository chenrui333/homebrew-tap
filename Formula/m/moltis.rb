class Moltis < Formula
  desc "Local-first personal AI gateway with plugin-driven channels"
  homepage "https://moltis.org/"
  url "https://github.com/moltis-org/moltis/archive/refs/tags/v0.9.10.tar.gz"
  sha256 "b9dc9f3c73242cd8c491a372a8f0c7cdbdf1bbb2355c73f6754669833fb6e842"
  license "MIT"
  head "https://github.com/moltis-org/moltis.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c2a2430fa8df947f7253d5cfda11ba74e860db747d7b2396518e92a2f7982b3a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "30556798a8fbcf6d07744a37733538b11f68c61b9b6a3d99ca6ef156fed604d5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "476f56d67ec0ca23d6885642bfb0344cd4617e3d1ecadbc83bd7277b06dbbb25"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3eec0d786eac011a2e740b597e753dfa751c578e0c64e26c2a6a2adc4aba76b6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8f7621b506f3bfd1e3eda538dbec90e42a1a840cc62a717af34c3f069a495096"
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
