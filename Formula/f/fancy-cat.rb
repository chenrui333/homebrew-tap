class FancyCat < Formula
  desc "PDF reader for terminal emulators using the Kitty image protocol"
  homepage "https://github.com/freref/fancy-cat"
  url "https://github.com/freref/fancy-cat/archive/refs/tags/v0.1.1.tar.gz"
  sha256 "8d07869f94eb6105a52684e13f67f3d844ea1bc54183dfeee20eb4f8f51524ce"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any,                 arm64_sequoia: "4a1648d9aa856b25eb37b98740ca257edced12b3ebe520c9f92c8a754ca7d22d"
    sha256 cellar: :any,                 arm64_sonoma:  "1854747203941a5c29c1aacf7716fcd2da1c4c07e6297e8d4a3d4e15e4ecf6fe"
    sha256 cellar: :any,                 ventura:       "3eae0e344024c866a340368ddfdb4f04eafb429f7b8ab22af39754234e08f846"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c745b33cf5192f3fa7745a790e976e6671df1ffde3bad2418d84145c41143bf0"
  end

  depends_on "zig" => :build
  depends_on "mupdf"

  # Enable `headerpad_max_install_names` to fix Mach-O relocation
  # upstream pr ref, https://github.com/freref/fancy-cat/pull/25
  patch do
    url "https://github.com/freref/fancy-cat/commit/5f26447cea580f7cd719b8ada4c36e71701cb3a7.patch?full_index=1"
    sha256 "757e9c10f7da7e68dcbb420eeae9325f72409ffd2e297738237f4458ed97d734"
  end

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
    system bin/"fancy-cat", "--version"
    assert_match "error: InvalidArguments", shell_output("#{bin}/fancy-cat 2>&1", 1)
  end
end
