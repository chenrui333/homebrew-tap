class FairygladeLy < Formula
  desc "TUI (ncurses-like) display manager for Linux and BSD"
  homepage "https://codeberg.org/fairyglade/ly"
  url "https://codeberg.org/fairyglade/ly/archive/v1.4.0.tar.gz"
  sha256 "3ee8f2f8c14a00437f7c3ec044bf5c95a6be45036c7ed5aa43c6f9eb91bf925a"
  license "WTFPL"
  head "https://codeberg.org/fairyglade/ly.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_linux:  "17ce760c6e08d27337b496484ad839394c244550fce31e8299fa43333404b672"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "ca14564d8db730847285d37e8faf8d72de0e36e4101e8b8b3167725d2556554e"
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
