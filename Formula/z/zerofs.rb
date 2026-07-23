class Zerofs < Formula
  desc "Serve S3 buckets as POSIX filesystems over NFS, 9P, or as block devices"
  homepage "https://github.com/Barre/ZeroFS"
  url "https://github.com/Barre/ZeroFS/archive/refs/tags/v2.1.1.tar.gz"
  sha256 "329d56eae17a9d0e0db44af4de17e42994196fc543e64b1182644d5a18d6670e"
  license "AGPL-3.0-only"
  head "https://github.com/Barre/ZeroFS.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ad13e4f635cda252cc6c8f5d4240051d9c63ce7fac80176f58d28113551815ff"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "477ff261fe8aae368c4ae1fad529e3a8435a948d17954178d0dbfad05d6a7865"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e9009707d0ce40bdab4de1aece874bb492b97ca3c8c9af4bac8d229d16bd0769"
    sha256 cellar: :any,                 arm64_linux:   "b19512608d54bb5cd108cae099130552eb02edd083a16c79c2a9719748ddd261"
    sha256 cellar: :any,                 x86_64_linux:  "d438504b72606eff0072dd9ee26ccc3150f2a0e2fe0f5faae94645b471e04373"
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
