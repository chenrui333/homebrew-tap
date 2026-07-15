class Hygg < Formula
  desc "Simplifying the way you read. Minimalistic Vim-like TUI document reader"
  homepage "https://github.com/kruserr/hygg"
  url "https://github.com/kruserr/hygg/archive/refs/tags/0.1.24.tar.gz"
  sha256 "0be91ce2ecceeaebcd40926b3c78f4867c056b93615c2a5ff01b4578d1f4b9dd"
  license "AGPL-3.0-only"
  head "https://github.com/kruserr/hygg.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7e63e8d13bbae8ede6d1f10c1082bed57eea7ecdbb09122ae4890a61b2632157"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7f651c772dc04106bb6a6b9a41c09a2c11af4a55a0b432d8d2ce08276ca5b340"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7c4c494291f9766d88773f6206582b232cf321c228e40d28564421af66c26361"
    sha256 cellar: :any,                 arm64_linux:   "fe763bff8218148f6ba2c727827c641c499dfdaa7faec6e5c8ab8011f3ce7326"
    sha256 cellar: :any,                 x86_64_linux:  "207ad988ba3093a6d801d57fb4324530d7b2e08d1d8d9f2f704a3069307066ec"
  end

  depends_on "rust" => :build
  depends_on "ocrmypdf"

  def install
    system "cargo", "install", *std_cargo_args(path: "packages/hygg")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/hygg --version")
    assert_match "Available demos", shell_output("#{bin}/hygg --list-demos")
  end
end
