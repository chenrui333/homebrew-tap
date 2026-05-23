class Netwatch < Formula
  desc "Real time network diagnostics in your terminal"
  homepage "https://github.com/matthart1983/netwatch"
  url "https://github.com/matthart1983/netwatch/archive/refs/tags/v0.17.1.tar.gz"
  sha256 "ea484803b68563fc0236e95ade1bd4e2adc07d75fe9eeda0dd172d4fbb577358"
  license "MIT"
  head "https://github.com/matthart1983/netwatch.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7e886555f082d1a5b5cc9621dea23db6f8f6c4ec369155a23e361f2bc27b0422"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e0295f845ee7001545c7f77d812fe0dd94d6f13469b3110b5a040c6be3bbd647"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "031a300f700a531f50479e39084be27718a311670444884ca3e72428d7a48867"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "cda50dc9fe7e3cad15e3541e447f27a268228885bce8bad64ef36b0fd8235eb7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c328ea1500835439b26b9f1fbedf5417cd942140858f94eabce6c70873bce8da"
  end

  depends_on "rust" => :build
  uses_from_macos "libpcap"

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match "netwatch", shell_output("#{bin}/netwatch --help 2>&1")
  end
end
