class Knip < Formula
  desc "Declutter your JavaScript & TypeScript projects"
  homepage "https://knip.dev/"
  url "https://registry.npmjs.org/knip/-/knip-5.54.0.tgz"
  sha256 "9dafd14a5213a7c4025ed71b1c301173e46827e96a574a30c8a9799abe96b556"
  license "ISC"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "af5b4b94dfebc94e9f0c96f0ea3a1bb7397af99d6571fa7aa8ad4e8576d2b98d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "cc3aa6d0991f560b90cee79334cd2fe72aae712195c4c393c4d42929f6ae2a81"
    sha256 cellar: :any_skip_relocation, ventura:       "be52993e9d0c7f981bafa53b5d3f5e307f5da0d02169c4d3bf29712b07412d5a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "96191092fdf11a952cc1bf652a070ef778f32c47837a18e7f9825fd12cce43de"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/knip --version")

    (testpath/"package.json").write <<~JSON
      {
        "name": "my-project",
        "scripts": {
          "knip": "knip"
        }
      }
    JSON

    system bin/"knip", "--production"
  end
end
