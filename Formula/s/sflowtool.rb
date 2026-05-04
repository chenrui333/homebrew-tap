class Sflowtool < Formula
  desc "Utilities and scripts for analyzing sFlow data"
  homepage "https://inmon.com/technology/sflowTools.php"
  url "https://github.com/sflow/sflowtool/releases/download/v6.10/sflowtool-6.10.tar.gz"
  sha256 "fda6358fed05e5f5de6f05e837fa7cefc8fb7a0f972399d07f21fd7698795eef"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4ee6227c948d378416d3b2762006ed11016e22420314c13714da1d0cfb8077ad"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e996628de9be1c0359745b3862e53974df404da726fb6d3437bb72932a9eaae6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b8d3897674046ceb64eec4d8252912a1df38cc54cb8cf5eb9299d25e29937f62"
    sha256 cellar: :any_skip_relocation, sequoia:       "08b63e345db3417b7a65822c436dff3411a1c7830924711ae6700fb8ab7b137f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "288bb8ad8d37f39368cead88ecdaf9082d752b76e139ea17d28e27fc2d5345e1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b5453815350339b6c478ec586e540c2a7269c9ce47b982c2f40c1085861c4886"
  end

  resource "scripts" do
    url "https://inmon.com/bin/sflowutils.tar.gz"
    sha256 "45f6a0f96bdb6a1780694b9a4ef9bbd2fd719b9f7f3355c6af1427631b311d56"
  end

  def install
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
