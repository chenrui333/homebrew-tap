class BuzzLang < Formula
  desc "Small/lightweight statically typed scripting language"
  homepage "https://buzz-lang.dev/"
  url "https://github.com/buzz-language/buzz.git",
      revision: "e4458fac501485208519035f093ff68405751534"
  version "0.5.0" # 0.5.0 tag actually uses zig 0.14-dev
  sha256 "c64aeb62039ec247289300b7ea6bf19055e2dd3bf25b87195d5d27a6f0c3e0c6"
  license "MIT"

  depends_on "zig" => :build

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
