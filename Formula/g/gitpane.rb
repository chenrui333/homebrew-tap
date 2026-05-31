class Gitpane < Formula
  desc "Multi repo Git workspace dashboard for the terminal"
  homepage "https://github.com/affromero/gitpane"
  url "https://github.com/affromero/gitpane/archive/refs/tags/v0.7.6.tar.gz"
  sha256 "a3d45ce0c5d1587e57dd01b03cc5a2d49165a2bbb2327233abd25b43707b7a5d"
  license "MIT"
  head "https://github.com/affromero/gitpane.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256               arm64_tahoe:   "3490f5555d72452bc90ad51510f7932f0a067bb244e9f08790266ca0348d16de"
    sha256               arm64_sequoia: "2d96391b9a07a2d78d3a198f4e91a5ea0bb80bb511975cf092891f9ca5eff669"
    sha256               arm64_sonoma:  "de2861a8b7b41a7b449db3fd28efd6cdea4afcfc7f8a6bb31a237ae2669f46f4"
    sha256 cellar: :any, arm64_linux:   "5968e34fd35be061874f6839dacc01646bdbe97075365347527ffb194495a2a6"
    sha256 cellar: :any, x86_64_linux:  "9d769b17e4c7b9807677b1e399a2c7b3162ed01948e662d35c6f7d3a0ed4b25d"
  end

  depends_on "rust" => :build
  depends_on "openssl@3"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  def install
    ENV["OPENSSL_DIR"] = Formula["openssl@3"].opt_prefix
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match "gitpane", shell_output("#{bin}/gitpane --help 2>&1")
  end
end
