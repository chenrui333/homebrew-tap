class Gitpane < Formula
  desc "Multi repo Git workspace dashboard for the terminal"
  homepage "https://github.com/affromero/gitpane"
  url "https://github.com/affromero/gitpane/archive/refs/tags/v0.7.3.tar.gz"
  sha256 "51d157eb6f912557cfbcbba942743c4b49a123aeebabc31b2d816700bca65850"
  license "MIT"
  head "https://github.com/affromero/gitpane.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256                               arm64_tahoe:   "b06fc68d45e5c11f5071d17936ba2f7d1c1671e0bb497b1d7f25e8533a690506"
    sha256                               arm64_sequoia: "4e3de37026f61901d93a6def7a6d18bb8dc7e73c7bb750f4ef37253917523b1a"
    sha256                               arm64_sonoma:  "018a3b9531ddfcf63287a1b8c69a7945b37150b71b3373d4d94d864fe01a22db"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2e7a2a25865c4e438193dc015a49cf4f0efdefeca2501345ffc238d21b08adbf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2bc1a224f2ec38421316c8ea5d2955873c34f746dba369a84bcda5ad9fd29d3a"
  end

  depends_on "rust" => :build
  depends_on "openssl@3"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  def install
    ENV["OPENSSL_DIR"] = Formula["openssl@3"].opt_prefix
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match "gitpane", shell_output("#{bin}/gitpane --help 2>&1")
  end
end
