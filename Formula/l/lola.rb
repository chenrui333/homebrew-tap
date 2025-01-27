class Lola < Formula
  desc "Programming language meant to be embedded into games"
  homepage "https://lola.random-projects.net/"
  url "https://github.com/ikskuh/LoLa/archive/fddcc3a04e759fa8a1f639eb5f86041a40dcb231.tar.gz" # for zig 0.13.0
  version "0.1"
  sha256 "ae996b9ca3137537dabe42926f61e1fa88a73315dab4c9b6d4469d1eeb242430"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a05a9cf1f1a33a8c720a1626817fe27df4631975176e63e4deb9e412774fc502"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3494b16b6b506d554b61c3e5df9e2b268a1a00291e1776ff6857ac8e4c702957"
    sha256 cellar: :any_skip_relocation, ventura:       "fd872b713dfe1c576b7568cf7fad66a6efc4e1378ae604f0166ce7742f5c36a1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3bd599b98e7a45c41bf80d79801dcd01d246520ff0e49184139c33123cef3237"
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
