class FlowEditor < Formula
  desc "Programmer's text editor"
  homepage "https://github.com/neurocyte/flow"
  url "https://github.com/neurocyte/flow/archive/refs/tags/v0.7.2.tar.gz"
  sha256 "f56313fd00a36ab04ee9a9ddb200aebf195df3882947a698c1d1760d4bbd1d4a"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "fd6f496a61963ecc8baf8b1694591bc847f6b515af54fc8289e653a2254eb246"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "810a85f2bbb4fe7e1d2c35749fb3fd9a6da4c22ef4e4c33a6af8a9dcb601a16b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "09d68e5a78ae466f0936939b1a1d777d6fbb02cde409a8be4a0f673050855295"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5048a3c5beaed109d15d7a75d6eb3776f5a4ceab93112299df676e4def4a937f"
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
    system bin/"flow", "--version"
  end
end
