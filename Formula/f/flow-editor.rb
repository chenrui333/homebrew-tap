class FlowEditor < Formula
  desc "Programmer's text editor"
  homepage "https://github.com/neurocyte/flow"
  url "https://github.com/neurocyte/flow/archive/refs/tags/v0.4.0.tar.gz"
  sha256 "6cf7e270163d2d067f033e699572ca092ef39b338ae238ca3a7c0cf16a63c30f"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "cb59215f05b8af8369a5b85f2ab143594b8f5666faee082e1cf7794de5b10d28"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e994c057e9257532d9902e44f0d42d7ecdd599af119829065371a721280efcac"
    sha256 cellar: :any_skip_relocation, ventura:       "527069581a787fe48b956540fec1b4ee124c7dc5fc597430894bce03b9d20e85"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8e96dcfcfb5319e262080313a95246afcf6c9288038ed52450e6d70d5d86e2b4"
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
