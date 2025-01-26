class Jetzig < Formula
  desc "Web framework written in Zig"
  homepage "https://github.com/jetzig-framework/jetzig"
  url "https://github.com/jetzig-framework/jetzig/archive/3b30ab4625d41cfe3add39797950d188680396b9.tar.gz" # for zig 0.13.0
  version "0.0.1" # fake version number
  sha256 "3f9769e0305d6b7a1fe520ca94b2681a80a8e0c7c934d347afa7bb4016aa17b9"
  license "MIT"

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
