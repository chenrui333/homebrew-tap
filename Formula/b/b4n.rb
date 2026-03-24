class B4n < Formula
  desc "Terminal user interface (TUI) for Kubernetes API"
  homepage "https://github.com/fioletoven/b4n"
  url "https://github.com/fioletoven/b4n/archive/refs/tags/v0.4.5.tar.gz"
  sha256 "6ae964924f6c5106ab0849dc3bb9344d11479355b06e2fda50f420ccc0786681"
  license "MIT"
  head "https://github.com/fioletoven/b4n.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e156f2ff42c49808bf4496de1daf344439dd359447520366b545e75d3e95b645"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "60dd18c701516199750f70e8f179e2cbe1f032ebcd0b799478a7fef0c1a16da1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "39ec984635c0cb10feffc880d559ffdc8dcbfc15164133d717821437e2ab4541"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "34a4b7bb4a33e5ceb0b43ea83ac609a98d88e870669419ab95265173e93a83ef"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4d5dd3ffb0b317318391c764f5c087d12eb30fc3b8f8e8446033c8aa0de275b7"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/b4n --version")
    assert_match "Error: kube config file not found", shell_output("#{bin}/b4n 2>&1", 1)
  end
end
