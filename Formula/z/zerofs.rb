class Zerofs < Formula
  desc "Serve S3 buckets as POSIX filesystems over NFS, 9P, or as block devices"
  homepage "https://github.com/Barre/ZeroFS"
  url "https://github.com/Barre/ZeroFS/archive/refs/tags/v2.2.3.tar.gz"
  sha256 "e9115e0c4938ed8240a8f5df356d86aded2ca21a19b2c8e6a299be81dd3d3432"
  license "AGPL-3.0-only"
  head "https://github.com/Barre/ZeroFS.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "af6569115bd8f4da58f42fc03ed705311df65b33ca686939f52abab5e2df25b9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "182924cc9423c004408d9b2d3d1f93ec63b678715b773e12cd99c8d5dfc5a852"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2a64181c52017f4ad31fde6ca316dbfd7f7f73a3bf7368e0bd6a29f704eea262"
    sha256 cellar: :any,                 arm64_linux:   "db9ea74d22ef567fbe80ff52d91888a58cec27139057180eb20f2ec5f0d69e63"
    sha256 cellar: :any,                 x86_64_linux:  "875e2593f931299570578f222babfa0397fc09c128ab07356a2d5460dfc98acf"
  end

  depends_on "cmake" => :build
  depends_on "rust" => :build

  def install
    # Upstream's jemalloc background_thread setting warns on macOS.
    inreplace "zerofs/.cargo/config.toml", ",background_thread:true", "" if OS.mac?

    system "cargo", "install", *std_cargo_args(path: "zerofs")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/zerofs --version")

    system bin/"zerofs", "init"
    assert_match "ZeroFS Configuration File", (testpath/"zerofs.toml").read
  end
end
