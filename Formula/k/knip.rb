class Knip < Formula
  desc "Declutter your JavaScript & TypeScript projects"
  homepage "https://knip.dev/"
  url "https://registry.npmjs.org/knip/-/knip-5.73.0.tgz"
  sha256 "363a5c8e7e9de49b6fc62d295f8931722a4a8a741096ee08794a185a928fd24b"
  license "ISC"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any,                 arm64_tahoe:   "4c88163628d17b982bc73b83713a147ef8a6570e94ad8320f9bb00b1e5f2b4a8"
    sha256 cellar: :any,                 arm64_sequoia: "d5a1cdb1c1d580144f7f53e02418dfd054ce2a3e39510681f4755aada45c8389"
    sha256 cellar: :any,                 arm64_sonoma:  "d5a1cdb1c1d580144f7f53e02418dfd054ce2a3e39510681f4755aada45c8389"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0b8bf4525e7206cf0529f525d54e9a393c745b40dc398ec84071b85ce64219c5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "004d5d3f9039f6b79e0a01c7a4731d279a6ac30d231ed4a37b58d43e0066f617"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    (testpath/"package.json").write <<~JSON
      {
        "name": "my-project",
        "scripts": {
          "knip": "knip"
        }
      }
    JSON

    assert_match version.to_s, shell_output("#{bin}/knip --version")

    system bin/"knip", "--production"
  end
end
