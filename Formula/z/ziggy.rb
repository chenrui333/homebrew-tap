class Ziggy < Formula
  desc "Data serialization language for expressing clear API messages, config files"
  homepage "https://github.com/kristoff-it/ziggy"
  url "https://github.com/kristoff-it/ziggy/archive/d762d0054bc84bf7e7f456cb5e22d5d749178505.tar.gz" # for zig 0.13.0
  version "0.0.2" # version after upstream's tag 0.0.1
  sha256 "a290ac25b95f99164ef695e034b0a79056f0f3e4eb961e6ba3fe61fc8edd1afb"
  license "MIT"

  bottle do
    root_url "https://github.com/chenrui333/homebrew-tap/releases/download/ziggy-0.0.2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5b36bb8ee903bda218bba788dd6eebf242c674bddcff373913b8eb1bcf14e1ed"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "41ed2c4818615339914327a3c778e42b3a8b5625af2cfec1d84f9da169be1e6f"
    sha256 cellar: :any_skip_relocation, ventura:       "49f3d03e4334cc962801026019b0a8278cddba66cceb2bf40bf1291581e15a1f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "10fe33f4b85f12d9301df234096ca5ce5a4f7dc13c86d5532d24d6f4f0b0413b"
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
    (testpath/"doc.zgy").write <<~EOS
      {.hello = "world",}
    EOS

    system bin/"ziggy", "fmt", "doc.zgy"

    expected = <<~EOS.chomp
      {
          .hello = "world",
      }
    EOS
    assert_equal expected, (testpath/"doc.zgy").read
  end
end
