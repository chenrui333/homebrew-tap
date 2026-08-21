class Zerofs < Formula
  desc "Serve S3 buckets as POSIX filesystems over NFS, 9P, or as block devices"
  homepage "https://github.com/Barre/ZeroFS"
  url "https://github.com/Barre/ZeroFS/archive/refs/tags/v2.3.0.tar.gz"
  sha256 "d556769b9a3de50a27f05adf82f3daf3146ae440578e1f344f4a9079d404ca51"
  license "AGPL-3.0-only"
  head "https://github.com/Barre/ZeroFS.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d5b9abb092e52d40289b2056b7af4ea6cd6d0de6c25a477454ca020283cced4b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "cacb23aadd3ea5b73cc964c0eefac765333e72d01df90b884323155658519160"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fed329be5a277474147ab9c3b031d1ce6224aae3de99ce373af0184753117be5"
    sha256 cellar: :any,                 arm64_linux:   "a1e1c415332787bdde623a4eb456ae92f60fa14f4daf31520e3bd4f51128655c"
    sha256 cellar: :any,                 x86_64_linux:  "12d10cb1479e0384239b2635d722f024721c838c882a2ffe8f754dc29865e5db"
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
