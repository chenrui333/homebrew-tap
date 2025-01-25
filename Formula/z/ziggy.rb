class Ziggy < Formula
  desc "Data serialization language for expressing clear API messages, config files"
  homepage "https://github.com/kristoff-it/ziggy"
  url "https://github.com/kristoff-it/ziggy/archive/d762d0054bc84bf7e7f456cb5e22d5d749178505.tar.gz" # for zig 0.13.0
  version "0.0.2" # version after upstream's tag 0.0.1
  sha256 "a290ac25b95f99164ef695e034b0a79056f0f3e4eb961e6ba3fe61fc8edd1afb"
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
