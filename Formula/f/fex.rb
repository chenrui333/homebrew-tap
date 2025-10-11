class Fex < Formula
  desc "Command-line file explorer prioritizing quick navigation"
  homepage "https://github.com/18alantom/fex"
  url "https://github.com/18alantom/fex/archive/b77ab14e4f42b3f8f866028b7770b54a2a1c9680.tar.gz"
  version "0.1.4"
  sha256 "1647866741bd2384121f0580ef47bb689fa9b329a38568b8f1c9ff8bba03de66"
  license "GPL-3.0-or-later"
  revision 1

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fc91544ff705a4c8ef572a688bde9692a71de10a45b84883e6b5feb38d2ce4a0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "aab5dcfac107ef3b44c5db99028b6f92ee4bbc48ba0ce7b7606cbed374e22db1"
    sha256 cellar: :any_skip_relocation, ventura:       "70c3ffd0f2b130dca1bc2538a3e23877ac9e2ede2185ecb72a84c362910c404a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4e1ae8158ca1318af2056b30ac9844944f82a82a57152ff1d1201e0036e09b07"
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
    assert_match version.to_s, shell_output("#{bin}/fex --version")

    _, stdout, = Open3.popen2("#{bin}/fex", testpath)
    assert_match "NotATerminal", stdout.gets("\n")
  end
end
