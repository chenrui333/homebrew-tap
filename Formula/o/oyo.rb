class Oyo < Formula
  desc "Step-through diff viewer"
  homepage "https://github.com/ahkohd/oyo"
  url "https://github.com/ahkohd/oyo/archive/refs/tags/v0.1.30.tar.gz"
  sha256 "9454a46fb1b7189151c3d264df88e6b0569df965f560d47dadc931e861158c2f"
  license "MIT"
  head "https://github.com/ahkohd/oyo.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a023fbbd64d83ac6f8c572f43e4b87b0085278317627a0c6347be11affc72a5f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3f68a5081ca38d453b2c1c663a997f1bd9bc0c4f0c0a33aa71f4e4aa63d5091e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f48e3ebe66b48b7fb27b952c52b322cec7e03ea1d5e0903aaf71588ea70ad1d3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "556955decfb90bc4a7ddaf17aad60ea03ad278025829859d7c92448f579248c3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1976cb8fdb287cd25decc3177c06746cc04d1ae9253181480de0ce8928cf7100"
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
