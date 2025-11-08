class Knip < Formula
  desc "Declutter your JavaScript & TypeScript projects"
  homepage "https://knip.dev/"
  url "https://registry.npmjs.org/knip/-/knip-5.68.0.tgz"
  sha256 "0f23bed561dec385ca560483fa9896991b9ff21d654d14b81a0d7031a1739aef"
  license "ISC"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any,                 arm64_tahoe:   "776c23c1d45a0969717f6333594e8eaa8ab3522ff6eb72f65fb585abd005f1e5"
    sha256 cellar: :any,                 arm64_sequoia: "d30d9cca9884f324c3a5a437200fc7c689f2b742f142a10ead2e4c7c18e152bd"
    sha256 cellar: :any,                 arm64_sonoma:  "d30d9cca9884f324c3a5a437200fc7c689f2b742f142a10ead2e4c7c18e152bd"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3a3a0f5acac70a3266f20a81c77fc032e3d44b9c6060e4aad75dfe9be1c312fc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2d36e3c6de12579f29eff4b412968e4b1488bfb0ccccb2857589d735aa1550b8"
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
