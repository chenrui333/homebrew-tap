class Zigscient < Formula
  desc "Zig Language Server"
  homepage "https://github.com/llogick/zigscient"
  url "https://github.com/llogick/zigscient/archive/refs/tags/0.14.15-3.tar.gz"
  sha256 "5c295fd98b957092cfffed76337c7bc59e78bf4c112577845efaf90454ecc048"
  license "ISC"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "fccaed829fb4781a1755d788f7274fe77128a9e3593b56b391140941f51311e8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6398370b0c69a8dccbcb952fc1127d0fb50daa46dfeda2b36f2a85c2be27e4b1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c9e765d2e0047350bd3125259e18a101f9ef13c7f627b8db1c66a6398207b9cc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ff36afcf2e67751bb54ceeb613a8f339ccc26c87d82764ba22dfaac8fa3e26b5"
  end

  depends_on "zig@0.14" => :build

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
