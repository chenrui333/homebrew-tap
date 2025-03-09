class Zigscient < Formula
  desc "Zig Language Server"
  homepage "https://github.com/llogick/zigscient"
  url "https://github.com/llogick/zigscient/archive/refs/tags/0.14.1.tar.gz"
  sha256 "58d2256c934543d08b5254bf054ad2c540b2295c6b076ae1c7a4dcea6ebcedf5"
  license "ISC"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ccb030bae951bdfc010c187fdd6a962229cf1b7cd7d9f354f5f3c917fa8db47f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3e01cd59adf44eb50767a86afefb91ef7e6d91dff100c39235207c842094b5c1"
    sha256 cellar: :any_skip_relocation, ventura:       "25f181cc4aa0dc4518deca96a369cf85c055310b919ff3cf6436153d3d40c133"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9fef0474aee30c32cb4dc3a77a7e882d9c7e49792b76580a0154e5e62abc46a8"
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
    assert_match version.to_s, shell_output("#{bin}/zigscient --version")

    output = shell_output("#{bin}/zigscient --show-config-path 2>&1")
    assert_match "path to the local configuration folder will be printed instead", output
  end
end
