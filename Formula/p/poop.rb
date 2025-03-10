class Poop < Formula
  desc "Performance Optimizer Observation Platform"
  homepage "https://github.com/andrewrk/poop"
  url "https://github.com/andrewrk/poop/archive/refs/tags/0.5.0.tar.gz"
  sha256 "b67d62c3583994fb262ccaf05094b215d3514d4d2935a25a3867dcab0cf89c93"
  license "MIT"
  revision 1

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "58748a9375bbde162f69a55f9c920067eb3e3c825a4aa471107ba16dbd7a2f99"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "73116ee7298e02fe3b83bfb7b0d9c276940dd85963377e8b6c1394711ac0b952"
    sha256 cellar: :any_skip_relocation, ventura:       "721bf504f50e7888c007dc482ca9c4ea99835685a268f675f6a6940b3fc782a8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "19c23a696d890f4e6a523cdd27627f16e3288ce84cf3b94c3d62b34b6f53ce88"
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
    assert_match "Compares the performance of the provided commands", shell_output("#{bin}/poop --help")
  end
end
