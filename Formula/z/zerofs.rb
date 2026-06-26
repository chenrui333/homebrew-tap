class Zerofs < Formula
  desc "Serve S3 buckets as POSIX filesystems over NFS, 9P, or as block devices"
  homepage "https://github.com/Barre/ZeroFS"
  url "https://github.com/Barre/ZeroFS/archive/refs/tags/v1.4.0.tar.gz"
  sha256 "b37a89bf41e7b3f5eef3899c73df6edffbb560e928b306073af81170a97b1c41"
  license "AGPL-3.0-only"
  head "https://github.com/Barre/ZeroFS.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9f8020fc23e44692f6c666c194b5d6349aa20490bc6284a8df349ebc2ff33f28"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b1fa44a0474ed924a97070f9b0f63eb4f4294001221086259cdd359b283b4dd3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9b8c0c0ee680c0d8157d9c71a251951082304e775da6810aeabf2f711f55a0d6"
    sha256 cellar: :any,                 arm64_linux:   "a66bc8b48502f354e73695ebc373f5d33c43cc0453471b37ed468a640e871544"
    sha256 cellar: :any,                 x86_64_linux:  "9a650595e147892cc2105cba88a1e3cad4aaa3357001621e73fc32fd694398e5"
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
