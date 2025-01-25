class Ziggy < Formula
  desc "Data serialization language for expressing clear API messages, config files"
  homepage "https://github.com/kristoff-it/ziggy"
  url "https://github.com/kristoff-it/ziggy/archive/d762d0054bc84bf7e7f456cb5e22d5d749178505.tar.gz" # for zig 0.13.0
  version "0.0.2" # version after upstream's tag 0.0.1
  sha256 "a290ac25b95f99164ef695e034b0a79056f0f3e4eb961e6ba3fe61fc8edd1afb"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "62c2e72282e734099cd2dc46c8112b2695d7d376887d794a4e7ec2e0c9d0e02b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ea2e3b4ab04e82853d4610c649b2ec218ccb580760f33f4cd99f6eab8e9f54fe"
    sha256 cellar: :any_skip_relocation, ventura:       "52f793a55d774bfa5ec0e52b95de0f8b8a0890a7d8e0708a7a8ee0c6e44a6a96"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ca0e0760f1619754bc5517cb4c6559b3c89ad4fd930e1e7722988715d81f7cd4"
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
