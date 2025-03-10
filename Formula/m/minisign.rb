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
    rebuild 2
    sha256 cellar: :any,                 arm64_sequoia: "bf2489e886bd6aa650356ce78b92c408207427be180359c95e987691926552ad"
    sha256 cellar: :any,                 arm64_sonoma:  "ec0a4d6745ac9df07a1ebdbf638d33a713788dbdf2d4eb6b077da26890fddfb8"
    sha256 cellar: :any,                 ventura:       "819a76c2ad72e655ed155ec8baa59949e2a2d83269a0994593486993148eaf2b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8db8e48a51bc043aea7996d58d9b68669b2a6d488fe583012aa7f1b64c1127a4"
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
