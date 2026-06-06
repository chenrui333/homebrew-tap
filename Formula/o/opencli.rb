class Opencli < Formula
  desc "Make any website or Electron App your CLI, AI-powered"
  homepage "https://github.com/jackwener/opencli"
  url "https://registry.npmjs.org/@jackwener/opencli/-/opencli-1.8.3.tgz"
  sha256 "21869cfae0782ce3787625dc45541e2864e71ca9d3fe5286f9da3b016843a540"
  license "Apache-2.0"
  head "https://github.com/jackwener/opencli.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, all: "615c96684636641ce62a71de65d55177bbcca2d2a3a54b8adc43510bae26b1e8"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/opencli --version")
    assert_match "opencli", shell_output("#{bin}/opencli --help")
  end
end
