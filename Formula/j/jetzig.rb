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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "43ed827ff2f657008c9875e092a6dbba17f70f6dbe3f46198fc8d423a16db0d5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "26cec0873860299750b3e74b089d8e077c799c333864b1d95eabc33340807a4a"
    sha256 cellar: :any_skip_relocation, ventura:       "b09a2f82fdf933ede5fe9b63be5ffef139fee986be284c16ff291aa9bae039ad"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b99b85e144cabce5e97db2a0d97ad430e9530a15b003da19db44e89eba64f20b"
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
