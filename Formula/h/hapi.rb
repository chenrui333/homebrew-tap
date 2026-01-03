class Hapi < Formula
  desc "Agentic coding - access coding agent anywhere"
  homepage "https://github.com/tiann/hapi"
  url "https://registry.npmjs.org/@twsxtd/hapi/-/hapi-0.4.1.tgz"
  sha256 "544fd1f506afb6656bdfe43422f05c92d0c34e713c19e1bb525c9f7c3351c744"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256                               arm64_tahoe:   "01adf1134903366e1b3bcb2402c9cf0a646dbccf77acf65ee3238c7e8d47458a"
    sha256                               arm64_sequoia: "01adf1134903366e1b3bcb2402c9cf0a646dbccf77acf65ee3238c7e8d47458a"
    sha256                               arm64_sonoma:  "01adf1134903366e1b3bcb2402c9cf0a646dbccf77acf65ee3238c7e8d47458a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3b6688f97cba1ce071a51a41f40e51126a7fe55f6ae519006bc3242b381d0bc4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2d52e82c47d5cdbd165657edd93ea2f62e7b37296cb8811569410a52a801fc16"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/hapi --version")
    assert_match "📋 Basic Information", shell_output("#{bin}/hapi doctor")
  end
end
