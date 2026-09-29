class FairygladeLy < Formula
  desc "TUI (ncurses-like) display manager for Linux and BSD"
  homepage "https://codeberg.org/fairyglade/ly"
  url "https://github.com/fairyglade/ly/archive/refs/tags/v1.4.1.tar.gz"
  sha256 "c0e26cdaf04415b3e66360b8d3efff3190dcfe62ee9d39bf7afcdfacaccc882a"
  license "WTFPL"
  revision 1
  head "https://codeberg.org/fairyglade/ly.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_linux:  "db6c11a5aa4e60c8a449c94d307919431dce36608d41c3eac0ce18d65d07ab6f"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "3fd64797ec716cd74d1cb44ed723af7472846916a3735ad64c7cfc1abc4d9e18"
  end

  depends_on "pkgconf" => :build
  depends_on "zig@0.16" => :build
  depends_on "libxcb"
  depends_on :linux
  depends_on "linux-pam"

  deny_network_access!

  def fetch
    system "zig", "build", "--fetch=all"
  end

  def install
    args = %W[
      --search-prefix #{formula_opt_prefix("libxcb")}
      --search-prefix #{formula_opt_prefix("linux-pam")}
    ]

    system formula_opt_bin("zig@0.16")/"zig", "build", *std_zig_args, *args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/ly --version 2>&1")
    # FIXME: Ly requires a Linux virtual terminal; add a functional test when upstream supports headless operation.
  end
end
