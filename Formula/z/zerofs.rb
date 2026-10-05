class Zerofs < Formula
  desc "Serve S3 buckets as POSIX filesystems over NFS, 9P, or as block devices"
  homepage "https://github.com/Barre/ZeroFS"
  url "https://github.com/Barre/ZeroFS/archive/refs/tags/v2.3.5.tar.gz"
  sha256 "50f138ed109f17b12d0cee6c7f9deb9e2c1ce38b5cfbce24ffb7353dc48a5036"
  license "AGPL-3.0-only"
  head "https://github.com/Barre/ZeroFS.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6be2bf2fd4d0e76403e0d4340dee34dbe287b4f0c4f0ef25735b41f0074fe651"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2297d591833dfcd8f78d5a81802810b156a6d95ec7cb54e513f85050a7a5b806"
    sha256 cellar: :any,                 arm64_linux:   "f1804441bc94eca72baac7980bfcc983d2879b4b46476a549512a63c88e6dca4"
    sha256 cellar: :any,                 x86_64_linux:  "4158873d5804c05d7b5d6029805e203be89befc5ea6ac2001bbb3ac38d3aa5c7"
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
