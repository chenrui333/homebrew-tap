class Zerofs < Formula
  desc "Serve S3 buckets as POSIX filesystems over NFS, 9P, or as block devices"
  homepage "https://github.com/Barre/ZeroFS"
  url "https://github.com/Barre/ZeroFS/archive/refs/tags/v2.3.1.tar.gz"
  sha256 "6a577802ba1874b3133dc3365d4a3087c68bb2c060dff393d35ab0eded9816fc"
  license "AGPL-3.0-only"
  head "https://github.com/Barre/ZeroFS.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "140a24b3004e8614d3c28bd8f94879b5b1029eb6b15dc61728edb6d78c8e52ce"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5de530a204a724f333ffd06e7c733fb82724936ca4533cd86b6cd0fc0652088d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "411cc9c3fbee42afb2735f8eae2250e039727882fc2928e4e7033666a272e5ca"
    sha256 cellar: :any,                 arm64_linux:   "b2d341c4a4be18ba27eb91f25bc425fac306ccae7f5dd594b51b7cef9ac36a30"
    sha256 cellar: :any,                 x86_64_linux:  "34e3de05866df58cc72f020aaff2c9b79e3981762106a400482a3b1c2c4c1326"
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
