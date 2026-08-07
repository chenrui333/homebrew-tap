class Zerofs < Formula
  desc "Serve S3 buckets as POSIX filesystems over NFS, 9P, or as block devices"
  homepage "https://github.com/Barre/ZeroFS"
  url "https://github.com/Barre/ZeroFS/archive/refs/tags/v2.2.2.tar.gz"
  sha256 "70370512a0821d69d064b34967acaea0a058d829c201947f20b9e1c72b98176a"
  license "AGPL-3.0-only"
  head "https://github.com/Barre/ZeroFS.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6dd9f189451ec67f98ec252f1663bd6c4db1b9f23af6e2dc6d357393c1ba42ff"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1cf7fa9ca243c87d529434787d751ed19d61040fafbcd049afc4bee84c1f7993"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "70dec05b0e20a9d0081f87a4601ee3ef24ff2dd35d4c4fd4ccbeacb1d78a55c2"
    sha256 cellar: :any,                 arm64_linux:   "6c890704a2f2c4cef9af87e15c598c6c1f110e83ee8d23f9beeec92136b643f5"
    sha256 cellar: :any,                 x86_64_linux:  "3d10c845493508041177b1c21c982ac2c3341174a3d5b1d5d53f0fdc733622bf"
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
