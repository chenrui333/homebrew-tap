class Minisign < Formula
  desc "Tool to sign files and verify digital signatures"
  homepage "https://github.com/jedisct1/minisign"
  url "https://github.com/jedisct1/minisign/archive/20ccc774085f3b865dd9c0b8fbc859bdaf8b1fa5.tar.gz" # for zig 0.15.1
  version "0.12"
  sha256 "0be35a734c1da8365136f4d8c485d720f1b305d59934bf0564aa493e451783cf"
  license "ISC"
  revision 2

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e1fbb6124d393c311f932c6d923da2d6f6b725c4c225dc832c75de996607efbf"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5336427d04c73346242c3918e1b3678830d7dbe10a335ea97d3d8304dc7ead8c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cf71deca0b0e4747fa7fa51b360687db68f0eed2a0b654ccdf6053f62703e713"
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
