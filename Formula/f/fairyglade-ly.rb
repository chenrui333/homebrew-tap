class FairygladeLy < Formula
  desc "TUI (ncurses-like) display manager for Linux and BSD"
  homepage "https://codeberg.org/fairyglade/ly"
  url "https://codeberg.org/fairyglade/ly/archive/v1.4.1.tar.gz"
  sha256 "16fe5f07cc7a23930880b14d905883644cdc4b574d1c146629f6b98ee8fbbab9"
  license "WTFPL"
  head "https://codeberg.org/fairyglade/ly.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_linux:  "db6c11a5aa4e60c8a449c94d307919431dce36608d41c3eac0ce18d65d07ab6f"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "3fd64797ec716cd74d1cb44ed723af7472846916a3735ad64c7cfc1abc4d9e18"
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
