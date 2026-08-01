class Zerofs < Formula
  desc "Serve S3 buckets as POSIX filesystems over NFS, 9P, or as block devices"
  homepage "https://github.com/Barre/ZeroFS"
  url "https://github.com/Barre/ZeroFS/archive/refs/tags/v2.2.1.tar.gz"
  sha256 "74b2a64f33f2db0ef2e60f87493c5d791aba0e63b65e64d346641a6dce4e060e"
  license "AGPL-3.0-only"
  head "https://github.com/Barre/ZeroFS.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "84c0317dd16eed05d520a34a58b0a9876477ef2bd275137a499588d647a65d00"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "682a7cbdf002bcc1ae572d5c9a52d8b08a322c1d9c855da2634112a5b8d4b7b7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f32850db98172a0147d4b85ba55b284629ab0c833d10fda8278f374f3458b7aa"
    sha256 cellar: :any,                 arm64_linux:   "c1f2d810570701d2f8384cd57705d14a7c87eaaa2d562b3d05bcadce8d9d2f59"
    sha256 cellar: :any,                 x86_64_linux:  "e5ef8e58e03541108afdf5a7c7905741963e328abc7ba612fbaacad74532765c"
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
