class Knip < Formula
  desc "Declutter your JavaScript & TypeScript projects"
  homepage "https://knip.dev/"
  url "https://registry.npmjs.org/knip/-/knip-5.86.0.tgz"
  sha256 "3ac84494b04dc3818656577285d8ac3a5b822485d69a4def2d98fdf441820baf"
  license "ISC"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any,                 arm64_tahoe:   "520ce41556d18fb0b2f72d35bfd54dd16e795b51d545825d5727ad2fab046f67"
    sha256 cellar: :any,                 arm64_sequoia: "0be4ae5b771a19ef222ba11f9f86c91c66df22e270ef3f554b8605acdd2c3bc2"
    sha256 cellar: :any,                 arm64_sonoma:  "0be4ae5b771a19ef222ba11f9f86c91c66df22e270ef3f554b8605acdd2c3bc2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "10b5a740fe30f472c8e3244b51919b2c889b9135633b2055c2f0b70129e5e80b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a2488d65730fc6ff7da5bf5b6ec10eb1c65fb5b65b0e20827a6c7375f3fe0ff6"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
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
