class Lola < Formula
  desc "Programming language meant to be embedded into games"
  homepage "https://lola.random-projects.net/"
  url "https://github.com/ikskuh/LoLa/archive/fddcc3a04e759fa8a1f639eb5f86041a40dcb231.tar.gz" # for zig 0.13.0
  version "0.1"
  sha256 "ae996b9ca3137537dabe42926f61e1fa88a73315dab4c9b6d4469d1eeb242430"
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

    system "zig", "build", *args

    # remove non-executable files in bin dir
    rm bin/"lola.wasm"
  end

  test do
    (testpath/"test.lola").write <<~EOS
      var list = [ "Hello", "World" ];
      for(text in list) {
        Print(text);
      }
    EOS

    assert_match <<~EOS, shell_output("#{bin}/lola run #{testpath}/test.lola")
      Hello
      World
    EOS
  end
end
