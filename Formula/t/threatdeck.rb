class Threatdeck < Formula
  desc "Terminal based threat intelligence monitoring and alerting platform"
  homepage "https://github.com/gripebomb/threatdeck"
  url "https://github.com/gripebomb/threatdeck/archive/refs/tags/v0.4.0.tar.gz"
  sha256 "e6e8f7ca93a3983f3b466fe7557269da2b0f50d142a44a09766f3c545d97e6e5"
  license "MIT"
  head "https://github.com/gripebomb/threatdeck.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "00aea5e6d6bf8d993f312875864c65de26343991f5c47a3ebe760592e7f96f4b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "32b6010bb666a3151f04618092b502dacc4f2a286373cd2ce699cf2e933226f7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c258d28e1e652fb1da54ac625c8a872b8e47bf8ad63f584752637ffac2e034a5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "91136c818902dfe01c721ae44c97ff5863a53a79f0a59ff9487d1253da907e72"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6870d631a9aa0052029ad22d2ae0905d3253dc1e6c337c7886c6ef0acc3a844a"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/ThreatDeck --version 2>&1")
  end
end
