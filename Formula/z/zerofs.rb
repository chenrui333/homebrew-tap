class Zerofs < Formula
  desc "Serve S3 buckets as POSIX filesystems over NFS, 9P, or as block devices"
  homepage "https://github.com/Barre/ZeroFS"
  url "https://github.com/Barre/ZeroFS/archive/refs/tags/v2.2.2.tar.gz"
  sha256 "70370512a0821d69d064b34967acaea0a058d829c201947f20b9e1c72b98176a"
  license "AGPL-3.0-only"
  head "https://github.com/Barre/ZeroFS.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "03a9ccf051d6579052a28603ef02b1492bc686bf5966f0a77b69cfdde224f318"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "dee950a293ac63a665d1cbbfe44ee24f66f05bc6001314d37e9a447b0b157dec"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "91aef20bd10779f264a86efce750c109ce138946c66b98e16ab94ccef87e9348"
    sha256 cellar: :any,                 arm64_linux:   "8b2c18c50592f26c151817a5bc739cda85caf2df234c1866ed7e03cf34e293c9"
    sha256 cellar: :any,                 x86_64_linux:  "2feb39b79882be88e065d4989c9b4d208cb34f785c4dbb0054d3a161b3cedf6f"
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
