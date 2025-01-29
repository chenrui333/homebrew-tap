class Flow < Formula
  desc "Programmer's text editor"
  homepage "https://github.com/neurocyte/flow"
  url "https://github.com/neurocyte/flow/archive/refs/tags/v0.3.0.tar.gz"
  sha256 "8a018a8a7ca80cf43c6b9ddd10ece44dd4e8fa3f85797fc94c8d15020475cc1c"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c521990016b20f9ee8d8cf8a1d4fd796880c705ebf7b74212fa6e37767db8b42"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "73020a693ed47bcc4ed2a82eb74df6639fc64e40e57a3447ef8a0c1f4af24e9d"
    sha256 cellar: :any_skip_relocation, ventura:       "7ec919f0c3f32c2e88ad070ab98bb641587b47a904ecfc791d72c64067f393f9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "798d2980761573eb30a3a0e8034fdb62255d20755146aae3a55c040313f2eb66"
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
