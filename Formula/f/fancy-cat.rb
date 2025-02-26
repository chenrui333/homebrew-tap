class FancyCat < Formula
  desc "PDF reader for terminal emulators using the Kitty image protocol"
  homepage "https://github.com/freref/fancy-cat"
  url "https://github.com/freref/fancy-cat/archive/refs/tags/v0.3.0.tar.gz"
  sha256 "82a881c04af2422a79a34c91f65064be7a65ef246df42d540273b1266b131ef1"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any,                 arm64_sequoia: "8d06f8b70d4681ceeeaa7ba800032f1c586860f861a146a4ea2763babb9e582a"
    sha256 cellar: :any,                 arm64_sonoma:  "e38b667ce208c0c6e3ba57ca2543ae0fd33526d42d8a8197c3f63825f4a38cc4"
    sha256 cellar: :any,                 ventura:       "9ca1bd72a9593396ae967e147e9c39beed6be0f9dff9410cc3a0c2a3874f8116"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e65938a24e7328a725e1c80b513af12aa9ce04cab6be9b011d6ff647e8e35447"
  end

  depends_on "zig" => :build
  depends_on "mupdf"

  def install
    # Fix illegal instruction errors when using bottles on older CPUs.
    # https://github.com/Homebrew/homebrew-core/issues/92282
    cpu = case Hardware.oldest_cpu
    when :arm_vortex_tempest then "apple_m1" # See `zig targets`.
    else Hardware.oldest_cpu
    end

    args = %W[
      --prefix #{prefix}
      -Doptimize=ReleaseSafe
    ]

    args << "-Dcpu=#{cpu}" if build.bottle?
    system "zig", "build", *args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/fancy-cat --version")
    assert_match "Usage: fancy-cat", shell_output("#{bin}/fancy-cat 2>&1")
  end
end
