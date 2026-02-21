class Moltis < Formula
  desc "Local-first personal AI gateway with plugin-driven channels"
  homepage "https://moltis.org/"
  url "https://github.com/moltis-org/moltis/archive/refs/tags/v0.9.10.tar.gz"
  sha256 "b9dc9f3c73242cd8c491a372a8f0c7cdbdf1bbb2355c73f6754669833fb6e842"
  license "MIT"
  head "https://github.com/moltis-org/moltis.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "51b34fd627e3048698f3ffb5fcc6dd149f9fa0e580b0a8ec515011a897b40f3f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3dda7c84156197e33f4a76be8d8043ba03a21352e657289fba631e45280fae9a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d80d6c4040315cb01151d5bcfdbb0e578dcd9bea401fc701f8f35f8bfe00abc4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "81708498b13dd1444a778855cfa2fa0eaef5b1c3e9a0092096ca9a52814e7b06"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b34e784b9b99d2d9c7d4acc6beaec83b1c404eb155f4cd23a6601ce9b89e3118"
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
