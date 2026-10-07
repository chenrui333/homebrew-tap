class Drydock < Formula
  desc "Dashboard for a fleet of Git repositories"
  homepage "https://github.com/yetidevworks/drydock"
  url "https://github.com/yetidevworks/drydock/archive/refs/tags/v1.2.2.tar.gz"
  sha256 "3ae8325f6a1e9d69a1540fef625f737fea9e63a860877176603e5a5eb88e06a5"
  license "MIT"
  head "https://github.com/yetidevworks/drydock.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1591300d0ac351f9158ce03e7676ad349a699fbd84b5305b54348a68189b251e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fed4f8a4b709c84c3afdd4955e879b69eadea32cdb5fa2226ebc5f1997638c22"
    sha256 cellar: :any,                 arm64_linux:   "106c37ecdd957589ee037ed2e670d9d930830d8035bc340429ebf5b1cf59e222"
    sha256 cellar: :any,                 x86_64_linux:  "1d1097168907d166de07a25bb44447f4b3576406e79efa89f9edb8a425614279"
  end

  depends_on "rust" => :build

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    system "cargo", "install", *std_cargo_args(path: "crates/drydock")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/drydock --version")
    output = shell_output("#{bin}/drydock config show")
    assert_match 'roots = ["~/Projects"]', output
  end
end
