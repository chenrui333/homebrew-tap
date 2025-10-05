class Hygg < Formula
  desc "Simplifying the way you read. Minimalistic Vim-like TUI document reader"
  homepage "https://github.com/kruserr/hygg"
  url "https://github.com/kruserr/hygg/archive/refs/tags/0.1.19.tar.gz"
  sha256 "36491747e9d47cf7d24ae0666fd2908535eac437e8223a6bd88465a90e1cf35a"
  license "AGPL-3.0-only"
  head "https://github.com/kruserr/hygg.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "458622fe4d29e2deae57ebf8fc7cdfaf79f2f0f50e6871778358d0515636af6f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2d4ea5cd556bdf6c7812fa5c964a2e254745aebe730953d455ae0ac95d92bc3d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c90ce560983e0744153961c41ddb8bc6d5ceabfb82da7789ec6a7b7b0188a648"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d8f29d8687e1e74d04a3f314663586240ef4985622b0757fc0d973ab68165138"
  end

  depends_on "rust" => :build
  depends_on "ocrmypdf"

  def install
    system "cargo", "install", *std_cargo_args(path: "hygg")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/hygg --version")
    assert_match "Available demos", shell_output("#{bin}/hygg --list-demos")
  end
end
