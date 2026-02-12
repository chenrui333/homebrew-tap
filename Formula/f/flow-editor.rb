class FlowEditor < Formula
  desc "Programmer's text editor"
  homepage "https://github.com/neurocyte/flow"
  url "https://github.com/neurocyte/flow/archive/refs/tags/v0.7.0.tar.gz"
  sha256 "d623259ba3c623df36b10b0d618a29588290b49ba8d69b48813c41495c6175b3"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "997ffac6e0580adbc2d3261b213b6a1bd978c356abf5ecbe1ca6e80cc0debb12"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "dcdf7b72379f7ee9e54af1971061bab917d6fa8294e58b6c7a3182c1dba67577"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6a7174ccbf016031547958f095ab1f01975d3c693bcd12cb939b91adab5032dc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "07ee5cb40ffc7e8b531b43100973ee867be1055f7c840cfe39d01484cb8391e1"
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
