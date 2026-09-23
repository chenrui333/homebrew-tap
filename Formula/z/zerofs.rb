class Zerofs < Formula
  desc "Serve S3 buckets as POSIX filesystems over NFS, 9P, or as block devices"
  homepage "https://github.com/Barre/ZeroFS"
  url "https://github.com/Barre/ZeroFS/archive/refs/tags/v2.3.5.tar.gz"
  sha256 "50f138ed109f17b12d0cee6c7f9deb9e2c1ce38b5cfbce24ffb7353dc48a5036"
  license "AGPL-3.0-only"
  head "https://github.com/Barre/ZeroFS.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "95cf5f451bccea2819893ab2f5497ecbcb72e09313afcda8b22e6276fd6c1ad6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "37f68f02e412781e83bf62e806ad81799e43231b8d7385848012b7214f742d64"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5aeee04e1dc1de1494be0d62bcff1f6dc8264eddd77dcce8252ae33a1ed6d602"
    sha256 cellar: :any,                 arm64_linux:   "5eae946fe361184af139053267294d8f6ed9e72542fa0ee0ef2a43789ee5a3a1"
    sha256 cellar: :any,                 x86_64_linux:  "70dccc891efc5f18c79009bc32096d9183ebff454378156554e36af7e050d445"
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
