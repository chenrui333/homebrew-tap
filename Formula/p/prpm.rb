class Prpm < Formula
  desc "Universal registry for AI coding tools"
  homepage "https://prpm.dev/"
  url "https://registry.npmjs.org/prpm/-/prpm-0.1.7.tgz"
  sha256 "597b71ec6c9d9f580a464569707fb4ba522dbb718d5f2b957608167bc6369a6f"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, all: "347d70501fe728e1d2f7201fb94ccee052922aa3b877649f619b78cb19411721"
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
