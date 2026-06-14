class BskyCli < Formula
  desc "Command-line client for Bluesky"
  homepage "https://github.com/harveyrandall/bsky-cli"
  url "https://github.com/harveyrandall/bsky-cli/archive/refs/tags/v1.9.1.tar.gz"
  sha256 "53b8725ee7310446e71a38cb05611eb8d3e65ebab4bcf74938c35e453886dbfc"
  license "MIT"
  head "https://github.com/harveyrandall/bsky-cli.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    rebuild 1
    sha256 cellar: :any_skip_relocation, all: "0420fde6408deef49725d9b120814a40e5366cb3d866c5d38800da7d0ef57e12"
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
    output = shell_output("#{bin}/bsky not-a-real-command 2>&1", 1)
    assert_match "not-a-real-command", output
  end
end
