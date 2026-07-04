class Zerofs < Formula
  desc "Serve S3 buckets as POSIX filesystems over NFS, 9P, or as block devices"
  homepage "https://github.com/Barre/ZeroFS"
  url "https://github.com/Barre/ZeroFS/archive/refs/tags/v2.0.3.tar.gz"
  sha256 "b9d98340e2c32fbd3f30ae6671e938cc1fd52f69a873d5984885395598aa5a8c"
  license "AGPL-3.0-only"
  head "https://github.com/Barre/ZeroFS.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f47e9f7eeec69be2a8550056bcd24bd13f11e9047ada60979ebcef3bb05d2321"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "139968e5fc4454777d0da535a6b69bcc31f051da9eacbe6523e349318e821a9d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5a998ae3023b97237b0358bd25edd5557697b608043830040d80e012c42a54e7"
    sha256 cellar: :any,                 arm64_linux:   "61a799d3ef46c6b0c95e39662ccfa5e0b84ea6843f907e3acc54e94c98dab441"
    sha256 cellar: :any,                 x86_64_linux:  "568f0e1d46fddb5c10d24b73539ee66650fa6494d93be1047804bc787507da22"
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
