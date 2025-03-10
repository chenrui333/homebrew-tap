class Ziggy < Formula
  desc "Data serialization language for expressing clear API messages, config files"
  homepage "https://github.com/kristoff-it/ziggy"
  url "https://github.com/kristoff-it/ziggy/archive/af41bdb5b1d64404c2ec7eb1d9de01083c0d2596.tar.gz" # for zig 0.14.0
  version "0.0.2" # version after upstream's tag 0.0.1
  sha256 "cb0e1933f3d62f1a3807736a5de6508d60e1e672733fa0cd597a79f2b95b0aa6"
  license "MIT"
  revision 1

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c7b075c26f86dc8f99a0b9c0583d4bac4dacd87c3555ac57fbf523398d2df139"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "358d0696ccb6fea61d692afdc85fd96f55eaf4e8c55b45accb008dc852742e43"
    sha256 cellar: :any_skip_relocation, ventura:       "61442e9e4157fe45cf647ab3d3ac1c6eb57d6be99685cf162a083af5d08a8cd7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b297225c4684b1a06082f1d1eee3ae963581589b2a7e100a87090b532efc5f75"
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
