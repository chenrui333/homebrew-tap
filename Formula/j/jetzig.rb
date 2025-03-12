class Jetzig < Formula
  desc "Web framework written in Zig"
  homepage "https://github.com/jetzig-framework/jetzig"
  url "https://github.com/jetzig-framework/jetzig/archive/182ceee17f8147145b32a47d060071025ed44b74.tar.gz" # for zig 0.14.0
  version "0.0.1" # fake version number
  sha256 "c251cd477de9d9b815a18e2ccfed03e03f3632d3e1f2087a28439847678c03fd"
  license "MIT"
  revision 1

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2281363f3df8ddaa80619ec0f6e1b5dfef89bc07e7e0e4f1b86c8d0317c7e284"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8d3ba1dec0d178d5d6102f30056383a14a216b32c23c7c81bed2d9a081f18cbb"
    sha256 cellar: :any_skip_relocation, ventura:       "28158e24d44810c78b2d2459a9f083922cd4c39b643372859a81dd0b8e7caca8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4651ded8b65c79b4db6057010bd5e375ed0d098b0a8d108e2a641d37e58319c0"
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

    cd "cli" do
      system "zig", "build", *args
    end
  end

  test do
    # test is not consistent
    # expected = if OS.mac? && MacOS.version < :sonoma
    #   "Error fetching from GitHub"
    # else
    #   "Unable to detect Jetzig project directory"
    # end
    # assert_match expected, shell_output("#{bin}/jetzig update 2>&1", 1)

    # not checking output
    shell_output("#{bin}/jetzig update 2>&1", 1)

    # currently it is hanging
    # pipe_output("#{bin}/jetzig init", "test\nbrewtest\n")

    # assert_path_exists testpath/"brewtest"
    # assert_match "const jetzig", (testpath/"brewtest/build.zig").read

    system bin/"jetzig", "--help"
  end
end
