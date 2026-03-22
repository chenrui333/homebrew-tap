class BskyCli < Formula
  desc "Command-line client for Bluesky"
  homepage "https://github.com/harveyrandall/bsky-cli"
  url "https://github.com/harveyrandall/bsky-cli/archive/refs/tags/v1.6.2.tar.gz"
  sha256 "8a58f53562da0e2530e57af9c7d3788fc0da2927eafb5c2a6260f007a3a4f27c"
  license "MIT"
  head "https://github.com/harveyrandall/bsky-cli.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, all: "985626a2fd81c19adff984d15c90b51370742d00a687d1240302e713b77d29c3"
  end

  depends_on "node"

  def install
    system "npm", "install", "--include=dev", *std_npm_args(prefix: false, ignore_scripts: false)
    system "npm", "run", "build"
    system "npm", "install", *std_npm_args

    bin.install_symlink libexec.glob("bin/*")
    generate_completions_from_executable(bin/"bsky", "completions", shells: [:bash, :fish, :zsh])
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/bsky --version")
    assert_match "_bsky_completions", shell_output("#{bin}/bsky completions bash")
  end
end
