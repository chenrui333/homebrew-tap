class Sig < Formula
  desc "Solana validator client implementation written in Zig"
  homepage "https://syndica.io/sig"
  # zig 0.13 pr, https://github.com/Syndica/sig/pull/166
  url "https://github.com/Syndica/sig/archive/5ddea9054ded6282af31a40d0313e8e13a72b3a7.tar.gz" # for zig 0.13.0
  version "0.2.0"
  sha256 "a8d71e20a06fe15dbbcecf9f430a8e02f30eedbeb19d966db568255b5c426f66"
  license "Apache-2.0"

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
    assert_match version.to_s, shell_output("#{bin}/sig --help")
    # Identity: 5W9ZHG5hsp1UzQ47ANCWG6pDiD7LqyWetZhsZjwQTYX6
    assert_match(/Identity: \w{43}/, shell_output("#{bin}/sig identity 2>&1"))
  end
end
