class Minisign < Formula
  desc "Tool to sign files and verify digital signatures"
  homepage "https://github.com/jedisct1/minisign"
  url "https://github.com/jedisct1/minisign/archive/41306e3e42400321944b4119c49c219f44ea07ff.tar.gz"
  version "0.12"
  sha256 "683fb5c29895765f78f742d9aa3e4aa685960bb12193184b7a78adcb63c9771e"
  license "ISC"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any,                 arm64_sequoia: "f12c8feffdf9709660d263c3f5504014d8624d3bf22ffb31ce36c6b6b0a52a23"
    sha256 cellar: :any,                 arm64_sonoma:  "9ce25d0354ba986b6f8862440d8be83caff4d552d57499551f275fa3429a2d9a"
    sha256 cellar: :any,                 ventura:       "29cd2658c5f30c04f48683dc2cba3e77f9a55606c766f249192805d65e3a841c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2b033fcf9d9dd1514960a6fe3f9caa34d71cf120ac183f65c6b550da6049a8b1"
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
