class Minisign < Formula
  desc "Tool to sign files and verify digital signatures"
  homepage "https://github.com/jedisct1/minisign"
  url "https://github.com/jedisct1/minisign/archive/41306e3e42400321944b4119c49c219f44ea07ff.tar.gz"
  version "0.12"
  sha256 "683fb5c29895765f78f742d9aa3e4aa685960bb12193184b7a78adcb63c9771e"
  license "ISC"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    rebuild 1
    sha256 cellar: :any,                 arm64_sequoia: "3dbebd26aa1f3113a1c98a63064ed34f0b258e8677f9502c0fe32e0f8348da6d"
    sha256 cellar: :any,                 arm64_sonoma:  "2844fece27f65c9c7881607976c3934b595c5374a7299e31a81ef762cd187d90"
    sha256 cellar: :any,                 ventura:       "57d7433388ad458a67c6b6df6482ba5255e48988e2320632126e48ae9bf5f177"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fd19b03dbbbbfe84a52488b26e8a39d16b07b019161ad945570f6c005470e70a"
  end

  depends_on "pkgconf" => :build
  depends_on "zig" => :build
  depends_on "libsodium"

  # linuxbrew library/include paths patch, upstream pr ref, https://github.com/jedisct1/minisign/pull/156
  patch do
    url "https://github.com/jedisct1/minisign/commit/b3c3e628b957b26d01a837bb44e6c2b82f05b0c4.patch?full_index=1"
    sha256 "a978c6805cbe13cf89960578e021c9311e9c0fb3e4d91de532ad9aaa4e0133d9"
  end

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
      -Dstatic=false
    ]

    args << "-Dcpu=#{cpu}" if build.bottle?
    system "zig", "build", *args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/minisign -v")

    (testpath/"testfile.txt").write "Hello from minisign test!"

    # Generate a new key pair (disable passphrase with -W).
    system bin/"minisign", "-G",
                          "-p", testpath/"public.key",
                          "-s", testpath/"secret.key",
                          "-W"

    # Sign the test file with our newly generated secret key.
    system bin/"minisign", "-S",
                          "-m", testpath/"testfile.txt",
                          "-x", testpath/"testfile.sig",
                          "-s", testpath/"secret.key",
                          "-W"

    # Verify the signature using our newly generated public key.
    system bin/"minisign", "-V",
                          "-m", testpath/"testfile.txt",
                          "-x", testpath/"testfile.sig",
                          "-p", testpath/"public.key"
  end
end
