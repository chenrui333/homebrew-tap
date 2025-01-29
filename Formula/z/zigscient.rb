class Zigscient < Formula
  desc "Zig Language Server"
  homepage "https://github.com/llogick/zigscient"
  url "https://github.com/llogick/zigscient/archive/refs/tags/0.13.0.tar.gz"
  sha256 "5b387fd76e912f501003eaa7cc0699256ac53cfbbb5110ea99f678f9d8c85c8e"
  license "ISC"

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
    assert_match version.to_s, shell_output("#{bin}/zls --version")
    zis_version = Formula["zig"].version.to_s
    assert_match zis_version, shell_output("#{bin}/zls --compiler-version")

    output = shell_output("#{bin}/zls --show-config-path 2>&1")
    assert_match "No config file zls.json found", output
  end
end
