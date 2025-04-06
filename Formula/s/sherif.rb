class Sherif < Formula
  desc "Opinionated, zero-config linter for JavaScript monorepos"
  homepage "https://github.com/QuiiBz/sherif"
  url "https://registry.npmjs.org/sherif/-/sherif-1.5.0.tgz"
  sha256 "9d34335e549940b1aa0ed4c2d96f6794863904ab30e9461c7bf8ff4dc879ca70"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "765a87449c89e48388840fac09a268c0aa038807f198a3c8df843a72f573fafa"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d993a60d3f3558c3755ff3106fc75c9e2508dd39ec50af5911d29e3dfe4a80db"
    sha256 cellar: :any_skip_relocation, ventura:       "97b1ebd18639c2b3df89575a91037ccb7e49deaf459eab973510d4d28ffb47e6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ddfc0a341788c163bc9c4823c19c8e0d8cea88efd8291bfcebeb822abd7f47f2"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    (testpath/"package.json").write <<~JSON
      {
        "name": "test",
        "version": "1.0.0",
        "private": true,
        "packageManager": "npm",
        "workspaces": [ "." ]
      }
    JSON
    (testpath/"test.js").write <<~JS
      console.log('Hello, world!');
    JS
    assert_match "No issues found", shell_output("#{bin}/sherif --no-install .")
  end
end
