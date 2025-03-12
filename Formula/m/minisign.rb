class Minisign < Formula
  desc "Tool to sign files and verify digital signatures"
  homepage "https://github.com/jedisct1/minisign"
  url "https://github.com/jedisct1/minisign/archive/108ea640ba92f1486841e747573017c282df7280.tar.gz"
  version "0.12"
  sha256 "2096baebd41025fb2407b37411c90343ee6029acd2e7b283c4ef6f15cb9efd07"
  license "ISC"
  revision 1

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any,                 arm64_sequoia: "91bdc168d229371e4b8aaf1902e46848d5126756f0d0ea41105c157f7d8dbf31"
    sha256 cellar: :any,                 arm64_sonoma:  "15dde59c4d2588c521b8158d6286f8c4ea8040837e3cfea25de2a05d2b2abef4"
    sha256 cellar: :any,                 ventura:       "4e5203ce8a9af450e1367cc50d159e7e6ef1aaa14365dd7d80a6f6cc36bd2b1d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e9bb2e029701d02fad0023c641bd634ae03dc412951b47f24109deba3816d094"
  end

  depends_on "pkgconf" => :build
  depends_on "zig" => :build
  depends_on "libsodium"

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
