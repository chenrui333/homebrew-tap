class FlowEditor < Formula
  desc "Programmer's text editor"
  homepage "https://github.com/neurocyte/flow"
  url "https://github.com/neurocyte/flow/archive/refs/tags/v0.4.0.tar.gz"
  sha256 "6cf7e270163d2d067f033e699572ca092ef39b338ae238ca3a7c0cf16a63c30f"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fd55903743f04d3afd50076a27d267944cc8503d19404c651181cfc5fbf259a0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c7c207504b3b9ff8056e1bf9a24d7a8a28674917192f78078710ecbaf2b097be"
    sha256 cellar: :any_skip_relocation, ventura:       "520f7c79ecd8dd6e7919e1f3e843bd31f6519ab7cc9094504f6ea4eaa99fa57d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "492722cd0f67032000591e03dfce7804a0997654065c7d47c105382ede217aae"
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
