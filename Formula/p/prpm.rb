class Prpm < Formula
  desc "Universal registry for AI coding tools"
  homepage "https://prpm.dev/"
  url "https://registry.npmjs.org/prpm/-/prpm-0.1.11.tgz"
  sha256 "e81ceaeb56d3e10d1d66f78213fa8fee27c8e3ffae28526ea77ebc511cce1e43"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, all: "0e86b0f02e8f13325c8adae3ad558959e6c88e7ee3647f9d4625b818a5f7a627"
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
