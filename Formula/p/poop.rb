class Poop < Formula
  desc "Performance Optimizer Observation Platform"
  homepage "https://github.com/andrewrk/poop"
  url "https://github.com/andrewrk/poop/archive/refs/tags/0.5.0.tar.gz"
  sha256 "b67d62c3583994fb262ccaf05094b215d3514d4d2935a25a3867dcab0cf89c93"
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
    assert_match "Compares the performance of the provided commands", shell_output("#{bin}/poop --help")
  end
end
