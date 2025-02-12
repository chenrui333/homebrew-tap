class FlowEditor < Formula
  desc "Programmer's text editor"
  homepage "https://github.com/neurocyte/flow"
  url "https://github.com/neurocyte/flow/archive/refs/tags/v0.3.3.tar.gz"
  sha256 "74f86b04645da075f0290d95f56d4ed663919b0123430b4c97222e3a012fbf73"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "eef8b726e7c126400f645f2e24937511494e13ecb0e48e1375d6fdabe23fb088"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6920926c80ae697937a304f50a44d32123fd0923ad522bdc18c5824d481ed1fe"
    sha256 cellar: :any_skip_relocation, ventura:       "930240b2467d5003325d2d7169fcf8a879e7df255c4d192eadcec46a89862e87"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4e005dac41a0ffd74a376a6f028c91ee9bc8fd43ac45be048344734b0f99b642"
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
