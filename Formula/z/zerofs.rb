class Zerofs < Formula
  desc "Serve S3 buckets as POSIX filesystems over NFS, 9P, or as block devices"
  homepage "https://github.com/Barre/ZeroFS"
  url "https://github.com/Barre/ZeroFS/archive/refs/tags/v2.0.9.tar.gz"
  sha256 "d10fb9333dbb2f663520a657b862686860a137f2237440d36437d1acf3d3f27b"
  license "AGPL-3.0-only"
  head "https://github.com/Barre/ZeroFS.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c2258cb6e0cf9529c1a1b5107b0fbb7af4fbf4fee6ac2f89143da4c15fb83cac"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a29b2bea4551d4a4651b756501407df35de12a869f94921fb24f73f081d50a59"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "905f9236317c471968333562250a5ba95739cc3c03b7ec0e6b3a16d64a93e407"
    sha256 cellar: :any,                 arm64_linux:   "dbd74ee04887dc5a2796088a8a81eaea509d6ae598845c8f862078edb93b8433"
    sha256 cellar: :any,                 x86_64_linux:  "4f06d7486340280d99e9045516c6495e8e2f3352cc2ebee414afe259b787c429"
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
