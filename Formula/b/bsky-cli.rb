class BskyCli < Formula
  desc "Command-line client for Bluesky"
  homepage "https://github.com/harveyrandall/bsky-cli"
  url "https://github.com/harveyrandall/bsky-cli/archive/refs/tags/v1.9.1.tar.gz"
  sha256 "53b8725ee7310446e71a38cb05611eb8d3e65ebab4bcf74938c35e453886dbfc"
  license "MIT"
  head "https://github.com/harveyrandall/bsky-cli.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, all: "0f102b6f8182937c940f46823b8ca01c423a949634bb699dc409965a961420a0"
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
