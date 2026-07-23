class Zerofs < Formula
  desc "Serve S3 buckets as POSIX filesystems over NFS, 9P, or as block devices"
  homepage "https://github.com/Barre/ZeroFS"
  url "https://github.com/Barre/ZeroFS/archive/refs/tags/v2.1.1.tar.gz"
  sha256 "329d56eae17a9d0e0db44af4de17e42994196fc543e64b1182644d5a18d6670e"
  license "AGPL-3.0-only"
  head "https://github.com/Barre/ZeroFS.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "879472081d9f61887a4b816c6cae22b83f822b8897a9ad15b0214a450bc2ad6b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "73e48479226a2dd361440cb954135fd0f19bf56ee159854e6ebf3bbfaf2fb71b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "840122398ae96ee2c4e5904c1ae96c491b8d74645c2aa7ce1e6f157b91054570"
    sha256 cellar: :any,                 arm64_linux:   "a4f45fc69b5fc4fb7e185df2ef3b412a4697f4657f882bc8fc30f807ea875070"
    sha256 cellar: :any,                 x86_64_linux:  "92d944ffbf8c23eab612196d5b009c991f6e4f534c1e4d27d041c1b072867678"
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
