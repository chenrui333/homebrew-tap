class Moltis < Formula
  desc "Local-first personal AI gateway with plugin-driven channels"
  homepage "https://moltis.org/"
  url "https://github.com/moltis-org/moltis/archive/refs/tags/v0.9.8.tar.gz"
  sha256 "103c820c4a1474b26bbd2affb7a9f7a19c8517ea2f8f26018612c3507e12efea"
  license "MIT"
  head "https://github.com/moltis-org/moltis.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "fef9c3471d3a0cf326147d301b7096087a05604ce9a25fb5e42c5d37ec9b5da5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "897729e4249746ef34b8f4bda9bb025b437a28b56af1af5b0b0cd4de744bf8ca"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "cd170a168a3f7d4ec28fde3472ec01919996f5cc629bcc144039be94443f2c24"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "fdcf59e3f2f7fb28a396493aeb8acc0b502b21823e506b647db2568b46a75733"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5076e7bdfc69c987792a8c38f45b09e2a7fa309cd81eeee964886b619f626974"
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
