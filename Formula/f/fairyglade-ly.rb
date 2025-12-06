class FairygladeLy < Formula
  desc "TUI (ncurses-like) display manager for Linux and BSD"
  homepage "https://codeberg.org/fairyglade/ly"
  url "https://codeberg.org/fairyglade/ly/archive/v1.3.0.tar.gz"
  sha256 "ced87076b513bda7687a0983238d18d316fbf2382c5bbd9b25b686fc6bf63bb4"
  license "WTFPL"
  head "https://codeberg.org/fairyglade/ly.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_linux:  "e1dd9d21e3ce8fb91f90b7da4f72f95b8ef2546b2a55e01aa948110f8fa5084a"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "aacdbb8ff7509bd50a9f6e2c1a1342d452240898337edfad3c2bf5714942e785"
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
