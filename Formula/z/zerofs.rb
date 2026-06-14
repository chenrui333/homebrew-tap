class Zerofs < Formula
  desc "Serve S3 buckets as POSIX filesystems over NFS, 9P, or as block devices"
  homepage "https://github.com/Barre/ZeroFS"
  url "https://github.com/Barre/ZeroFS/archive/refs/tags/v1.2.5.tar.gz"
  sha256 "bcec5cab4b073aa55f6a2cb2b88d99074322cc8ff3aa6ce915e71f508b607b3b"
  license "AGPL-3.0-only"
  revision 1
  head "https://github.com/Barre/ZeroFS.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c3fc4bb196c829a5615aab7e4fb15c295047c7da346678ef6bec0c2102f9df90"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "94bba5e558f22b2c3a77bf61d3221e552db54430e19981d48380970c71965172"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9bae54b74b52356a981f8862af0b178ae27495eabe364d8ad66c2641a4e85e1d"
    sha256 cellar: :any,                 arm64_linux:   "f31fce40b8a61cdb55c26632a18c9287c1a2eea88df08f048b9aa7455a872e9c"
    sha256 cellar: :any,                 x86_64_linux:  "d3db5ef048ab0c9ad7e95f1f2e4e41228718d909d10436af40b59344efba111a"
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
