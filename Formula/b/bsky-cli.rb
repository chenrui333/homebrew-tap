class BskyCli < Formula
  desc "Command-line client for Bluesky"
  homepage "https://github.com/harveyrandall/bsky-cli"
  url "https://github.com/harveyrandall/bsky-cli/archive/refs/tags/v1.4.0.tar.gz"
  sha256 "4dc54213c954a75c5f31ac91b6d79199809b30a8b6ad921a9bf46ba75bb6ab84"
  license "MIT"
  head "https://github.com/harveyrandall/bsky-cli.git", branch: "main"

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
