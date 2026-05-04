class Sflowtool < Formula
  desc "Utilities and scripts for analyzing sFlow data"
  homepage "https://inmon.com/technology/sflowTools.php"
  url "https://github.com/sflow/sflowtool/releases/download/v5.05/sflowtool-5.05.tar.gz"
  sha256 "048c52ead856a23e927fb826ac7663aeaac98795e678792fd6f74c588f90825d"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0614dfd9b4be61720b94eccef208c6c306b9b839f1b75499714b6efd6a4d7787"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e2dcf44639d6cbdc3c66ec8b6390143cba9c7862fbeab5d0ceed350d7e4929e5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "892811efd5eb81e4db5f5b4d1f3a45352f8c55c37eea8cb2b02a9b40818babb0"
    sha256 cellar: :any_skip_relocation, sequoia:       "771a6a44e50e396c6118393f7a155a5b14dd924385df62e69bc9010b9023552d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3c68e159d05542abf48735cebd9141662de8a07ff4df84b71037ad013bde2ec1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "78893d7cc589788fc2aa198471615dd0ae0c5ae298934dd354a61d125a67aab6"
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
