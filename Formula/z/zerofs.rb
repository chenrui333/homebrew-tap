class Zerofs < Formula
  desc "Serve S3 buckets as POSIX filesystems over NFS, 9P, or as block devices"
  homepage "https://github.com/Barre/ZeroFS"
  url "https://github.com/Barre/ZeroFS/archive/refs/tags/v2.3.7.tar.gz"
  sha256 "15208738460ac82443dcfcd9cc27695da4814c220ca5be96e1f8f1c8b61d30bd"
  license "AGPL-3.0-only"
  head "https://github.com/Barre/ZeroFS.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "883b5add27cfbf056de8640df21911f08bfb688be420e7ce33f17107e28f8c35"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "48956093292fd428137b12c993acfc577fbbd78d4bd4e01ca4f1643a7721995e"
    sha256 cellar: :any,                 arm64_linux:   "681b31b7d7a2e646bbb389c810ec42367e42b09b59b171b28cf0e8a7b5547579"
    sha256 cellar: :any,                 x86_64_linux:  "d8bb84205a351d47c72f4e43f5a697308dd652b7ec41b3680ecd0708531cb8e5"
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
