class Sig < Formula
  desc "Solana validator client implementation written in Zig"
  homepage "https://syndica.io/sig"
  # zig 0.13 pr, https://github.com/Syndica/sig/pull/166
  url "https://github.com/Syndica/sig/archive/5ddea9054ded6282af31a40d0313e8e13a72b3a7.tar.gz" # for zig 0.13.0
  version "0.2.0"
  sha256 "a8d71e20a06fe15dbbcecf9f430a8e02f30eedbeb19d966db568255b5c426f66"
  license "Apache-2.0"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "30b734feb682dba0d6864312b2f33b61aeae5fc7c969465850fa66b9bd110b03"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "703080275d83f4db12b74d8b07df7f9700c0193584c0e7e65e24b24c3eb9b580"
    sha256 cellar: :any_skip_relocation, ventura:       "9857d2f204b17390441eb9241428f606c8b5ba74ee12b15b473d1cae069b1161"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "559be70f1997733c0d6b057d4d028bec37e394b1343d7ac91db1626df9d28d76"
  end

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
