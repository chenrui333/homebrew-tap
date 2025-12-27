class Knip < Formula
  desc "Declutter your JavaScript & TypeScript projects"
  homepage "https://knip.dev/"
  url "https://registry.npmjs.org/knip/-/knip-5.78.0.tgz"
  sha256 "a36d26c555a814ad5d45eb5b127b8c66b00a98c0209dd254e8ee0a23ad6e59a2"
  license "ISC"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any,                 arm64_tahoe:   "1700c8ecbe69548eb3509c173afdbf4a289bce59682fc7830750f6ad75127599"
    sha256 cellar: :any,                 arm64_sequoia: "9488cb1bff9f2dcb6c1ee0c63309674f2ea44e790760314c42493bef6dbd8844"
    sha256 cellar: :any,                 arm64_sonoma:  "9488cb1bff9f2dcb6c1ee0c63309674f2ea44e790760314c42493bef6dbd8844"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a27d8f39836b4aadd3a51f4a340cb747db2c145e1345f3f1f5cc07a2080c8172"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9c87b39cfaa6e3d0f39b1e121c944a73f2d671f952979ae2896f594c2dffe3e9"
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
