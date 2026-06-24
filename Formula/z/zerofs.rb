class Zerofs < Formula
  desc "Serve S3 buckets as POSIX filesystems over NFS, 9P, or as block devices"
  homepage "https://github.com/Barre/ZeroFS"
  url "https://github.com/Barre/ZeroFS/archive/refs/tags/v1.3.0.tar.gz"
  sha256 "51ff77e3021e3cd2e16ce42e90af30749886088db06fc05743f58d46f169f65a"
  license "AGPL-3.0-only"
  head "https://github.com/Barre/ZeroFS.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "12a129af58312529e36edefef4a14d94126a5303a1fcc7eeb2b944501a5cd9d2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d9ae2c67d8b8165c81eaa313155019078dadf045fd546469c88b8bad38428c55"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "bd8bd27fa3623d24264c2835e2f000db97e456d648f32064813a87a21b5bd745"
    sha256 cellar: :any,                 arm64_linux:   "913bf5e42d198c20ef62594c5b7e9445ff261ad4aa5381ade9a4c6b3956e6907"
    sha256 cellar: :any,                 x86_64_linux:  "d7712eb8a952fe73d0cf9b47ba56a47d3efcc6cd8604e3dae8461368ad40e201"
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
