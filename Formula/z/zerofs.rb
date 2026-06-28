class Zerofs < Formula
  desc "Serve S3 buckets as POSIX filesystems over NFS, 9P, or as block devices"
  homepage "https://github.com/Barre/ZeroFS"
  url "https://github.com/Barre/ZeroFS/archive/refs/tags/v1.4.4.tar.gz"
  sha256 "0b2f4350435424c2bf0559aaaed91d0b09b903605c075c0c886fb2319a6f3f95"
  license "AGPL-3.0-only"
  head "https://github.com/Barre/ZeroFS.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f4a0c16e3db94aa3fc2b46c8d446020d259b0c19e560d8c4a2345310cfebba07"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4d4d9d71cd61046faef702009c1d3694e6b5f181a2d9ba5e1ec09600926b3a0d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d3918a78a4c2d0f61a2671c13af42861920fc8abb264f4ac0ca4a37c2a9305d7"
    sha256 cellar: :any,                 arm64_linux:   "ad579df504edf0fee2c1dbe81a145c32ae8c209ab67dc7a06e00a6fabd41d031"
    sha256 cellar: :any,                 x86_64_linux:  "2bad9c8613fe78db4d10b3f40b6e35c658dcdeb4cd8e34cb3ddd1839097410bf"
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
