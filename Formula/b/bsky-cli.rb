class BskyCli < Formula
  desc "Command-line client for Bluesky"
  homepage "https://github.com/harveyrandall/bsky-cli"
  url "https://github.com/harveyrandall/bsky-cli/archive/refs/tags/v1.9.0.tar.gz"
  sha256 "201180b279b2d18a7ad6c49bdba6fc2e6e2e51c291a2d99e4f72e92b34657b68"
  license "MIT"
  head "https://github.com/harveyrandall/bsky-cli.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, all: "b2237cbe4762c82998033cb5c6775060290a3169ce235b941243a771be7c24cc"
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
