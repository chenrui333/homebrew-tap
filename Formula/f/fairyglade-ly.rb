class FairygladeLy < Formula
  desc "TUI (ncurses-like) display manager for Linux and BSD"
  homepage "https://codeberg.org/fairyglade/ly"
  url "https://codeberg.org/fairyglade/ly/archive/v1.4.0.tar.gz"
  sha256 "3ee8f2f8c14a00437f7c3ec044bf5c95a6be45036c7ed5aa43c6f9eb91bf925a"
  license "WTFPL"
  head "https://codeberg.org/fairyglade/ly.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_linux:  "2c13ea0c6c6c91fa00e0e7419730372d6a4eca7f2d3436cb3d7ec5b39833bbe9"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "40f71491e3923630c54f40d2a190ab2a0a087fac2b9a7875cf467c3def934b87"
  end

  depends_on "pkgconf" => :build
  depends_on "zig" => :build
  depends_on "libxcb"
  depends_on :linux
  depends_on "linux-pam"

  def install
    args = %W[
      --search-prefix #{Formula["libxcb"].opt_prefix}
      --search-prefix #{Formula["linux-pam"].opt_prefix}
    ]

    system Formula["zig"].opt_bin/"zig", "build", *std_zig_args, *args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/ly --version 2>&1")
  end
end
