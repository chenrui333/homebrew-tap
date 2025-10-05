class Hygg < Formula
  desc "Simplifying the way you read. Minimalistic Vim-like TUI document reader"
  homepage "https://github.com/kruserr/hygg"
  url "https://github.com/kruserr/hygg/archive/refs/tags/0.1.19.tar.gz"
  sha256 "36491747e9d47cf7d24ae0666fd2908535eac437e8223a6bd88465a90e1cf35a"
  license "AGPL-3.0-only"
  head "https://github.com/kruserr/hygg.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9e7033bb305f4d3119cb465ed7b89616c1348442cf0ada5af92f11169d5aa14d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "62188dfee58bd7f29bb7ec12c28a4af7bcdc09b31b9ea97b6de51b5ec87ba1bb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f92416fe55928ac40babcabc9bab7eaef397ea278e80b26eea9cb37918ab5537"
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
