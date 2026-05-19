class Sflowtool < Formula
  desc "Utilities and scripts for analyzing sFlow data"
  homepage "https://inmon.com/technology/sflowTools.php"
  url "https://github.com/sflow/sflowtool/releases/download/v6.11/sflowtool-6.11.tar.gz"
  sha256 "510ded7e1074d56abe1a702162cddf327ab0179f0f1dde27a44150a9489bfbfa"
  license :cannot_represent

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5ffca328767d72a0eb9e7bcea003807fc77cac0f63aed4d276ff6ebabbd6f88e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d37c83d9808b1841cf3487fe6eda6872cbe1b803e6e140410f6e39a1c363262e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b0b38f77e2555159a5b27d42ba45dc97ddd8fb7ed92de790a494a5470c4f249f"
    sha256 cellar: :any_skip_relocation, sequoia:       "a6a4c385536306e55e520bc5eafcac7c2d27c9293352a404d1af04545d47e8e5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "eafb68a478bfd0ea7298cee4beabf0e978642107a88e30c17eced4163c29ab52"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4393557ad99f40caaed8e311f71051c3b1d8456136e5349bbb6a6ed640a61547"
  end

  resource "scripts" do
    url "https://inmon.com/bin/sflowutils.tar.gz"
    sha256 "45f6a0f96bdb6a1780694b9a4ef9bbd2fd719b9f7f3355c6af1427631b311d56"
  end

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
