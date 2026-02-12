class FlowEditor < Formula
  desc "Programmer's text editor"
  homepage "https://github.com/neurocyte/flow"
  url "https://github.com/neurocyte/flow/archive/refs/tags/v0.7.0.tar.gz"
  sha256 "d623259ba3c623df36b10b0d618a29588290b49ba8d69b48813c41495c6175b3"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d7002bbcb2fa36dfb04019d36b7cc5002ea607740f6e63191b85386a8b210bdc"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8b708430a772d230538ed60b2c39de204f75a6955f9a03e6a0d7a39566e4b180"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6f92501a5968406187a2b3ab38b81f631a09364c7bfe2096e09ddb55efcf2372"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0a82bff20a17f585761dda0718f608f4ba1211ab0bfe6a5a6e649a6b5201e0a1"
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
