class Zerofs < Formula
  desc "Serve S3 buckets as POSIX filesystems over NFS, 9P, or as block devices"
  homepage "https://github.com/Barre/ZeroFS"
  url "https://github.com/Barre/ZeroFS/archive/refs/tags/v1.4.3.tar.gz"
  sha256 "39a1b8b7c016be8f78411a161bc7ef862128b6232b9f76ed2877d4d1ee5f8803"
  license "AGPL-3.0-only"
  head "https://github.com/Barre/ZeroFS.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f340d002b0d2070abb4f0cb0f650545fdae16d7bf9215b898b6c81b512ca4795"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ca901ca46b77b11bd02ea4e57a2588c1cb32b9de5de1139b3b4a146fc1c7b1e1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e0f15695cb8e84462e94d0db7846bd4ef8b2dfd603da033aa58f6cb897b8f4db"
    sha256 cellar: :any,                 arm64_linux:   "5833be79b21c9bdee890b932ccc736028cd2f46f2e0a2cf38c4428d8ce0d4756"
    sha256 cellar: :any,                 x86_64_linux:  "2e71cbcfbe7555d34694451a21117de7a70370fdfaeea025d8e943fff654711f"
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
