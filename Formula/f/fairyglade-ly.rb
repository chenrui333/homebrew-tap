class FairygladeLy < Formula
  desc "TUI (ncurses-like) display manager for Linux and BSD"
  homepage "https://codeberg.org/fairyglade/ly"
  url "https://codeberg.org/fairyglade/ly/archive/v1.3.1.tar.gz"
  sha256 "4d1742691abf8f43ecde389760ddd69140996eeacc0485728f09b27d8f99c6d7"
  license "WTFPL"
  head "https://codeberg.org/fairyglade/ly.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_linux:  "7b361106d456ec9839683ad79ab57e56059a8546b1f4d9cf19bf744711707010"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "089fbd740ed4ab865b58db44a87a490e57adc42adfd1036f26b3250f577b2203"
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
