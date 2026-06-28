class Zerofs < Formula
  desc "Serve S3 buckets as POSIX filesystems over NFS, 9P, or as block devices"
  homepage "https://github.com/Barre/ZeroFS"
  url "https://github.com/Barre/ZeroFS/archive/refs/tags/v1.4.4.tar.gz"
  sha256 "0b2f4350435424c2bf0559aaaed91d0b09b903605c075c0c886fb2319a6f3f95"
  license "AGPL-3.0-only"
  head "https://github.com/Barre/ZeroFS.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "33d4bc0e39e8243e8d941c67a11293a8780484cc3d0515e55f6b99909ef55879"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bc7c0efa9e1015d52158722820921c1c536fd0a4704d0d28871291fd655a1126"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "82eb2a5be5dd63f9d4c189c8c6aa2652b9476450456c80962793d4b639d9cc55"
    sha256 cellar: :any,                 arm64_linux:   "7390edf59ca44ee59eb78f34298b1c9c8bd67084e9c1275d17930060ed2156ca"
    sha256 cellar: :any,                 x86_64_linux:  "61768c3b6c4768e7f49b3589e0a27f5b1b0f3d6cafecc69316d1daf7e08655c4"
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
