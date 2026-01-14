class Knip < Formula
  desc "Declutter your JavaScript & TypeScript projects"
  homepage "https://knip.dev/"
  url "https://registry.npmjs.org/knip/-/knip-5.81.0.tgz"
  sha256 "a1856879a18e5be2d430c5bcf34671797528ee3997a435f3f130e55b49675d17"
  license "ISC"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any,                 arm64_tahoe:   "28ccde4fd5647ad5bbc7e8f8675c3310c66938b66a27e1bdd1a3aaba4e551afc"
    sha256 cellar: :any,                 arm64_sequoia: "c2c0b3a2a9218e469de8879313fb55f3b71c692b66e8aa441d4d1f749f6cfa51"
    sha256 cellar: :any,                 arm64_sonoma:  "c2c0b3a2a9218e469de8879313fb55f3b71c692b66e8aa441d4d1f749f6cfa51"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "23b69d40292d26b24828deb848587f7369f8014edb85d17cdc5510eb8caf46db"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "49ae8a8bde9b2b7c6f229e270f07fcf7c2886c39c3982ce069f00e60bf851cce"
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
