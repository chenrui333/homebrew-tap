class FairygladeLy < Formula
  desc "TUI (ncurses-like) display manager for Linux and BSD"
  homepage "https://codeberg.org/fairyglade/ly"
  url "https://codeberg.org/fairyglade/ly/archive/v1.3.2.tar.gz"
  sha256 "db069cc2dcacc64b2890552a10ec8547aee4f9b9e5b0bc6b07c3d5d431a757e6"
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
    # Fix illegal instruction errors when using bottles on older CPUs.
    # https://github.com/Homebrew/homebrew-core/issues/92282
    cpu = case ENV.effective_arch
    when :arm_vortex_tempest then "apple_m1" # See `zig targets`.
    when :armv8 then "xgene1" # Closest to `-march=armv8-a`
    else ENV.effective_arch
    end

    args = []
    args << "-Dcpu=#{cpu}" if build.bottle?

    system "zig", "build", *std_zig_args, *args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/ly --version 2>&1")
  end
end
