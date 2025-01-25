class FancyCat < Formula
  desc "PDF reader for terminal emulators using the Kitty image protocol"
  homepage "https://github.com/freref/fancy-cat"
  url "https://github.com/freref/fancy-cat/archive/refs/tags/v0.1.1.tar.gz"
  sha256 "8d07869f94eb6105a52684e13f67f3d844ea1bc54183dfeee20eb4f8f51524ce"
  license "MIT"

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
