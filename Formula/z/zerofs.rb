class Zerofs < Formula
  desc "Serve S3 buckets as POSIX filesystems over NFS, 9P, or as block devices"
  homepage "https://github.com/Barre/ZeroFS"
  url "https://github.com/Barre/ZeroFS/archive/refs/tags/v1.4.0.tar.gz"
  sha256 "b37a89bf41e7b3f5eef3899c73df6edffbb560e928b306073af81170a97b1c41"
  license "AGPL-3.0-only"
  head "https://github.com/Barre/ZeroFS.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c85b5bbbabfdbf032d134673b3d6d881d748bb26fa64e36befaded747a841a5b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8c530d6c6e6a449e6f893d8d4bae9974810fbeb74a0bc59a430b69842e4ac5a1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "bc80725e2df6fcd79ce3d6be28ca7daa0de6e1f6be53eb8a6e3202dad34bbc23"
    sha256 cellar: :any,                 arm64_linux:   "73d2193c4ab2199cdcf5c6f963a068bbd7e1ae2217cced67e12667a960847218"
    sha256 cellar: :any,                 x86_64_linux:  "5333bbeec429f031c989c05c0d9b9129ab305428b9b89a9a8b9bbe5d671f7ebf"
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
