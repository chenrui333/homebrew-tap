class Fex < Formula
  desc "Command-line file explorer prioritizing quick navigation"
  homepage "https://github.com/18alantom/fex"
  url "https://github.com/18alantom/fex/archive/refs/tags/v0.1.4.tar.gz"
  sha256 "a6e51e07802442e2e938197f78b287816ea2688200c9c86738d44230d4bc780e"
  license "GPL-3.0-or-later"

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
