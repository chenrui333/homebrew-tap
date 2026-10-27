class Zerofs < Formula
  desc "Serve S3 buckets as POSIX filesystems over NFS, 9P, or as block devices"
  homepage "https://github.com/Barre/ZeroFS"
  url "https://github.com/Barre/ZeroFS/archive/refs/tags/v2.3.6.tar.gz"
  sha256 "f760f606a305ea6db1756247eaef9171ad0eacb3d94576c71d2ffd59daaa754a"
  license "AGPL-3.0-only"
  head "https://github.com/Barre/ZeroFS.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ae7a14aef5271c711a6d5ef3e7228193a3f6a643a7fff29bc2396bdd605fe4bd"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "184c7c47bc707bee7ab66c5323ec394cc99dd2e0f7df9f23a7d094e4f9d73c94"
    sha256 cellar: :any,                 arm64_linux:   "7654594a1b7406ab75f3daa5c05ca1a023a1a1f247e316db12fb4bef4140cb9b"
    sha256 cellar: :any,                 x86_64_linux:  "7f175d4e8df3af80844dd28716e8f0b74cc90e52455d4c8b315ce61befaea81d"
  end

  depends_on "cmake" => :build
  depends_on "rust" => :build

  deny_network_access!

  def fetch
    cd "zerofs" do
      system "cargo", "fetch", *std_cargo_fetch_args
    end
  end

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
