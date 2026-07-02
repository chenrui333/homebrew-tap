class Zerofs < Formula
  desc "Serve S3 buckets as POSIX filesystems over NFS, 9P, or as block devices"
  homepage "https://github.com/Barre/ZeroFS"
  url "https://github.com/Barre/ZeroFS/archive/refs/tags/v2.0.0.tar.gz"
  sha256 "fc4ff9770e04dd151b19796b673317c7cbebceb2d3f8c526397933ffd6a2cd93"
  license "AGPL-3.0-only"
  head "https://github.com/Barre/ZeroFS.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6d488d906aef59c2209c709c71a5da627e53f4ab0fa8f16e0289a7abddce51e6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d6995a0584d8a586637f80cea98670812f0cacf6337fbd2e546b8f973c591e25"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2afa846ecebfd8a66a504a16c7740ce90c0fa34a74c26a1017765c92c5c0893b"
    sha256 cellar: :any,                 arm64_linux:   "a20a07558434be39f474a226ad255e37a9c223344d2c1790466a7fc874fccccd"
    sha256 cellar: :any,                 x86_64_linux:  "d3ec940afecc90633a0aeb1a356bfa8f4881a0a90e7b0e27dba6d211e76e3475"
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
