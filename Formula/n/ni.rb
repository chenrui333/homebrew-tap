class Ni < Formula
  desc "Use the right package manager"
  homepage "https://github.com/sindresorhus/ni"
  url "https://registry.npmjs.org/@antfu/ni/-/ni-24.1.0.tgz"
  sha256 "ea07d45c0345d80ed76cf9416416bca13fc20606ede90b89d8d2881cbe687ca9"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "02b196dc863a0cfc1bf4c2d12022b40cfd17d6e5d81aebb75e455afcca37fa45"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "aae95574e2838d945a8b6ba8cbba7cc40f0503bc31e39dfb63fd0ac9b5e67733"
    sha256 cellar: :any_skip_relocation, ventura:       "603f08967c54f68a83e140e12455e821a07d97868715c3afe79489df378ff724"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7d63be73061f7373cf6344a5c5e6a139edd25764f71fa13ff996a24b96635fbe"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec/"bin/ni"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/ni --version")

    (testpath/"package.json").write <<~EOS
      {
        "name": "test",
        "version": "1.0.0"
      }
    EOS

    output = pipe_output("#{bin}/ni", "npm\n", 0)
    assert_match "found 0 vulnerabilities", output
    assert_path_exists testpath/"package-lock.json"
  end
end
