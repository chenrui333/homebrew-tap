class Wedl < Formula
  desc "CLI to download from https://wetransfer.com"
  homepage "https://github.com/gnojus/wedl"
  url "https://github.com/gnojus/wedl/archive/refs/tags/v0.1.11.tar.gz"
  sha256 "1d52adf91a6a0424e54610741b48384135ee2e7c4c2bf13e8a9f6f4d301dd1dc"
  license "Unlicense"
  revision 1
  head "https://github.com/gnojus/wedl.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9f57e0f0cf0da8c2dced9b2d96e70020e544d4fa1ec997ddd8609a5bee7075c1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9f57e0f0cf0da8c2dced9b2d96e70020e544d4fa1ec997ddd8609a5bee7075c1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6d8c8bf109b6935352263e3131d55f0032e6fa447e0df8c975f3279b19e14c4b"
    sha256 cellar: :any,                 x86_64_linux:  "0e7eaa7f18306c6b1309914bd7170f6bd791370f18d1cadf673a47659ce01b33"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.version=#{version}")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/wedl --version")
    # system bin/"wedl", "https://we.tl/responsibility"
    # assert_path_exists testpath/"WeTransfer_Responsible_Business_Report_2020.pdf"
  end
end
