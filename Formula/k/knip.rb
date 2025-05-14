class Knip < Formula
  desc "Declutter your JavaScript & TypeScript projects"
  homepage "https://knip.dev/"
  url "https://registry.npmjs.org/knip/-/knip-5.56.0.tgz"
  sha256 "eeb81baa5ec8f550a29b09c6c0c1cfbb7af6431ef8d8986ca4177fc8b8b9c6bb"
  license "ISC"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "88f0e4b3df3227b26cd8229edf1f446aca4eecf16e9fe361416061ad19ed5951"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "95d03f17b813c4d46ffde75891bb2669655c3da210e0c071055ca507e7861a19"
    sha256 cellar: :any_skip_relocation, ventura:       "73f3ca036352dc8e0cdecd812a04762b1d31e6d18f05a1351b06e4bc59d932da"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "116e66eefefdd4b91a6b3f087145d329d3d36b28fbed9635b0c3f40855b8422e"
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
