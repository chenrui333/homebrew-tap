class Zerofs < Formula
  desc "Serve S3 buckets as POSIX filesystems over NFS, 9P, or as block devices"
  homepage "https://github.com/Barre/ZeroFS"
  url "https://github.com/Barre/ZeroFS/archive/refs/tags/v2.0.2.tar.gz"
  sha256 "5ee6ceb1531f3df268abaa22867008d96ef48f38f462a8a155ceaf53b75715c8"
  license "AGPL-3.0-only"
  head "https://github.com/Barre/ZeroFS.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a13735e3b36948353a21d68fbabe1762845836f2793f1725b364ec574503b660"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6a8dafeff45485960d525e10aaed064c4ce206ecc7e40c7fd5a968ef8d7ff872"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "03be3e86c70a9556f4107962e26db371ac8ec805f97e858e3a0978698c40b155"
    sha256 cellar: :any,                 arm64_linux:   "46ac2443851c2a27a29b82bf9808981f6d996ce7ebdf3a5b23e6741d2dfd0431"
    sha256 cellar: :any,                 x86_64_linux:  "d97014e72784f7941560e4423e574bcb1f0e766e110e72018ba284388401fb7c"
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
