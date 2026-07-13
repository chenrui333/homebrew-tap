class Oyo < Formula
  desc "Step-through diff viewer"
  homepage "https://github.com/ahkohd/oyo"
  url "https://github.com/ahkohd/oyo/archive/refs/tags/v0.1.47.tar.gz"
  sha256 "2fe1e63cafe37cfc96a9580fa225eb2b59f7f4ddd42c3ffdcc917762d6577302"
  license "MIT"
  head "https://github.com/ahkohd/oyo.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "fe56c5ad0942c6d460caab24ad4c50dfabf945a1519143ae753c9392681f0824"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "63fd9f1acea60e9c347b8f56721ebf0342dccdbd9f20f584b84a97736f8f9849"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9d8f5f1e3c515cd55a8933832c76f659741ede6b9ae0e39a44e6a3507765de41"
    sha256 cellar: :any,                 arm64_linux:   "a432b27912c6c18104a858a18d2f80eb4fb4d7b70370ec563b727c6f8cae7e27"
    sha256 cellar: :any,                 x86_64_linux:  "d502eb9e09e61dd0dcc9a7b47fa6254c89836ece8970fc182b4a8be220e1c867"
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
