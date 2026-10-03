class Gistui < Formula
  desc "Terminal interface for GitHub Gists"
  homepage "https://github.com/akunzai/gistui"
  url "https://github.com/akunzai/gistui/archive/refs/tags/v0.25.0.tar.gz"
  sha256 "56872aa640d71fe7e384dad9f2daafd0e507967e3bef7aa6a71467a1bfbebb07"
  license "MIT"
  head "https://github.com/akunzai/gistui.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "50e907e684bb77b6747619efde7f138ff34e233e9be38f4491f19112e6f070f9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4d3a8fb242fca5269edd5dee1d3cd7b1b72d0f562cd0768a35d4dabf9b820f6e"
    sha256 cellar: :any,                 arm64_linux:   "7d653ade175059d05448b98e6a3a1d7d08d9cfa66f5745fcfa3c1dd0e2668476"
    sha256 cellar: :any,                 x86_64_linux:  "0d9481b5a0743d66d0fae26ef6969412be1d0bd866d49496744d66ef0430eea3"
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
