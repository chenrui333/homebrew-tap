class Gistui < Formula
  desc "Terminal interface for GitHub Gists"
  homepage "https://github.com/akunzai/gistui"
  url "https://github.com/akunzai/gistui/archive/refs/tags/v0.25.0.tar.gz"
  sha256 "56872aa640d71fe7e384dad9f2daafd0e507967e3bef7aa6a71467a1bfbebb07"
  license "MIT"
  head "https://github.com/akunzai/gistui.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f1ba5921a28f17ab4dc16a4d1164d0c3cd0df0973d9de0ac8a9ecd9202419b62"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "45780a788537af4498412f176be9f7bb405b1129fb03f44aab805a031a7957bb"
    sha256 cellar: :any,                 arm64_linux:   "91d766c521400b60cf9a190681953f96c46e458569179cf138a99bae973cab59"
    sha256 cellar: :any,                 x86_64_linux:  "29218fe990450842d3ff153fa1fb1c4013135ecc4f884766e00580000b68b711"
  end

  depends_on "rust" => :build
  depends_on "gh"

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/gistui --version")
    output = shell_output("#{bin}/gistui #{testpath}/missing 2>&1", 1)
    assert_match "path does not exist", output
  end
end
