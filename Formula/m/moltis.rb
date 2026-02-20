class Moltis < Formula
  desc "Local-first personal AI gateway with plugin-driven channels"
  homepage "https://moltis.org/"
  url "https://github.com/moltis-org/moltis/archive/refs/tags/v0.9.3.tar.gz"
  sha256 "51cd6068bf1ed9a20377578f9254fb3a33377da09bcd15489a26e33463310948"
  license "MIT"
  head "https://github.com/moltis-org/moltis.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "028b848d6eef1293732bd837c95eb8d9116d0c442c8efccbde58209505a89d26"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c4c1f84b2b33ab714f4cb4d8bdad886ef239329223fdf20347b066309b14d480"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "82abd6b722791f566e91c0bf9e3d2bd55eedc95dac8c25ddcb9ef8c047338b44"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ad7c657eb25b3fbe2030d9ec674a437fce3cddf7a0211c095d2f6300dc3be68c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f7b5b4c5e744cc3a7b7b583b8219c98d6f9897bf02b00c99dea74e02a01f8759"
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
    ENV["HOME"] = testpath

    assert_match version.to_s, shell_output("#{bin}/moltis --version")
    assert_match "No issues found.", shell_output("#{bin}/moltis config check 2>&1")
  end
end
