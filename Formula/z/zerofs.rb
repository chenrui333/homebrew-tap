class Zerofs < Formula
  desc "Serve S3 buckets as POSIX filesystems over NFS, 9P, or as block devices"
  homepage "https://github.com/Barre/ZeroFS"
  url "https://github.com/Barre/ZeroFS/archive/refs/tags/v2.0.0.tar.gz"
  sha256 "fc4ff9770e04dd151b19796b673317c7cbebceb2d3f8c526397933ffd6a2cd93"
  license "AGPL-3.0-only"
  head "https://github.com/Barre/ZeroFS.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4e3005e5f4c8f451d7c8d112e5f4d5d26ff058e7e5fab7c9c1048bf8f51aa736"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "40930fbe84a80e88bb90c8860dff6d8cc8bd637011502948e635c308acf058f7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "23a9a3af716c16efab4843bca45656af432692613f289d037dcee16df24bc68d"
    sha256 cellar: :any,                 arm64_linux:   "6524e9dd48849f985b6aa061504b083d801aa824d60f4dc9be3381aee55912df"
    sha256 cellar: :any,                 x86_64_linux:  "b83260be9fd5192a4733f8b603fe90a70249bf79be83828705101bebcac67a1d"
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
