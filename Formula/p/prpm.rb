class Prpm < Formula
  desc "Universal registry for AI coding tools"
  homepage "https://prpm.dev/"
  url "https://registry.npmjs.org/prpm/-/prpm-0.2.0.tgz"
  sha256 "6a282b6793f9f8dbac306872e3101c194591d2f393bf2e7c4cc574d8475dfa6d"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, all: "a773c5797cfcd5a1f345d8a19a91998b4c11eab0c3af3ffed2e854e2b779622c"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/prpm --version")

    system bin/"prpm", "init", "--yes"
    assert_path_exists testpath/"prpm.json"
    assert_match "A PRPM package", (testpath/"README.md").read

    assert_match "No packages installed", shell_output("#{bin}/prpm list")
  end
end
