class Gritql < Formula
  desc "Query language for searching, linting, and modifying code"
  homepage "https://docs.grit.io/"
  url "https://github.com/getgrit/gritql.git",
      tag:      "v0.1.0-alpha.1743007075",
      revision: "fe3643396dab7b5cfa62ccd76d23cb0f03cf93e0"
  license "MIT"
  head "https://github.com/getgrit/gritql.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "813f99e6a4a8969e4135948c466b99fae6b73ddfd681185f060c258ccf6a727f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "13d71a08405879b1c42a993c78e83d081466d0f2afa1c1d37b1d51ea5fb3b4d9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "971dc949ec27962552d1e74faba0818e767531b6d1d04ea178837ef275c2433a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6c2882d668b02b66423205a7bca0c9127db6ff1a972e408179a97177051dea93"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "50782edde61d78b81c49abdbcd2d2529c868c64575ca84a43817eaea13f71f88"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "openssl@3"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  def install
    system "cargo", "install", *std_cargo_args(path: "crates/cli_bin")
  end

  test do
    system bin/"grit", "--version"
    system bin/"grit", "list"
  end
end
