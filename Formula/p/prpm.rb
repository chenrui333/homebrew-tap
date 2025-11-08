class Prpm < Formula
  desc "Universal registry for AI coding tools"
  homepage "https://prpm.dev/"
  url "https://registry.npmjs.org/prpm/-/prpm-0.1.10.tgz"
  sha256 "53e1a2c4b393632499f96719b1aeead7a65542b4da2e95408305b8428df7ae60"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, all: "0dfca06fb48702c9417cfa06d641138c7d86fb126526ac5aab5b424dad5fc56f"
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
    assert_match "# README.md", (testpath/"README.md").read

    assert_match "No packages installed", shell_output("#{bin}/prpm list")
  end
end
