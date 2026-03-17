class BskyCli < Formula
  desc "Command-line client for Bluesky"
  homepage "https://github.com/harveyrandall/bsky-cli"
  url "https://github.com/harveyrandall/bsky-cli/archive/refs/tags/v1.6.0.tar.gz"
  sha256 "36d9ea05c5ab0a7b482a0ad61f5f04dc190767c68e0d1f8b5b96cc23780e423f"
  license "MIT"
  head "https://github.com/harveyrandall/bsky-cli.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, all: "3708decaafee67f49f115f79931b8ffd72889eacc2df8f400eeb5dd1fe9727e7"
  end

  depends_on "node"

  def install
    inreplace "src/index.ts", '.version("1.0.0")', ".version(\"#{version}\")"

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
