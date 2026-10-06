class Sflowtool < Formula
  desc "Utilities and scripts for analyzing sFlow data"
  homepage "https://inmon.com/technology/sflowTools.php"
  url "https://github.com/sflow/sflowtool/releases/download/v6.11/sflowtool-6.11.tar.gz"
  sha256 "510ded7e1074d56abe1a702162cddf327ab0179f0f1dde27a44150a9489bfbfa"
  license :cannot_represent

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ea9cc76e56973cdefeff065b85d46f6b159ae5852846de74b42d83e0ebd4beae"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bf372a6d1b7f2ca105ced91a0a36a58100a61acadfb383fa52d625638a375801"
    sha256 cellar: :any,                 arm64_linux:   "1f1659a224d54a5874688b41838e270db76cfe263175a718958cf95953a3bd78"
    sha256 cellar: :any,                 x86_64_linux:  "efab8577209f54d04e9367011ecf8cbbc07c5a6c49357b90ef858badacf92206"
  end

  resource "scripts" do
    url "https://inmon.com/bin/sflowutils.tar.gz"
    sha256 "45f6a0f96bdb6a1780694b9a4ef9bbd2fd719b9f7f3355c6af1427631b311d56"
  end

  deny_network_access!

  def install
    # IPV6_HDRINCL is not available on macOS
    inreplace "src/sflowtool.c",
              "if(setsockopt(sfConfig.netFlowOutputSocket6, IPPROTO_IPV6, IPV6_HDRINCL",
              "#ifdef IPV6_HDRINCL\n  if(setsockopt(sfConfig.netFlowOutputSocket6, IPPROTO_IPV6, IPV6_HDRINCL"
    inreplace "src/sflowtool.c",
              "    fprintf(ERROUT, \"setsockopt( IPV6_HDRINCL ) failed\\n\");\n    exit(-13);\n  }",
              "    fprintf(ERROUT, \"setsockopt( IPV6_HDRINCL ) failed\\n\");\n    exit(-13);\n  }\n#endif"

    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make"
    system "make", "check"
    system "make", "install"
    (prefix/"contrib").install resource("scripts")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/sflowtool -h 2>&1")
  end
end
