class Zerofs < Formula
  desc "Serve S3 buckets as POSIX filesystems over NFS, 9P, or as block devices"
  homepage "https://github.com/Barre/ZeroFS"
  url "https://github.com/Barre/ZeroFS/archive/refs/tags/v2.3.5.tar.gz"
  sha256 "50f138ed109f17b12d0cee6c7f9deb9e2c1ce38b5cfbce24ffb7353dc48a5036"
  license "AGPL-3.0-only"
  head "https://github.com/Barre/ZeroFS.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "dbc4b423ae068e5d19b82c63621ee53423125caf85ae7fadde5510adc33f7457"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "14eaac751a7a9135cc01111e17c45f9a551f59b99f92330545e234a33578481b"
    sha256 cellar: :any,                 arm64_linux:   "adc2846329f91393b77f0cd50c42640a7469f8364942605140b6b6cbeccee254"
    sha256 cellar: :any,                 x86_64_linux:  "83a66d0623b6b46a2292a4e6016bcb0d28896bb05cc32a3fe08cfbb5b54c183a"
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
