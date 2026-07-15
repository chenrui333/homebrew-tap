class Oyo < Formula
  desc "Step-through diff viewer"
  homepage "https://github.com/ahkohd/oyo"
  url "https://github.com/ahkohd/oyo/archive/refs/tags/v0.1.51.tar.gz"
  sha256 "9b8e061b3b39a7ed0fabf44c748d15496c4e099b8794849fc68c5d91bf784be7"
  license "MIT"
  head "https://github.com/ahkohd/oyo.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "627e3aa8ba98f3fa4e957c3838544b285e54baeab4b3a3c67425a67f34d3ccfc"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1f53dcfa4a1b7cbe70db662ffa51613dc42b13882837a6da7066857a7e4410db"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a1a99493bba0b1dd7ff83f37665be4e149ce348f09cf95201a86a06b8963d85f"
    sha256 cellar: :any,                 arm64_linux:   "f31e2b0cccd987162658a9ffa36565ea95ff82ca118c11cb04cf21e462ab48b4"
    sha256 cellar: :any,                 x86_64_linux:  "fdea795fc9ef2bab62c5f9917fda0382fb933cd08524c065a6ad0986b345c801"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "oniguruma"

  def install
    system "cargo", "install", *std_cargo_args(path: "crates/oyo")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/oy --version")
    assert_match "github", shell_output("#{bin}/oy themes")
  end
end
