class Knip < Formula
  desc "Declutter your JavaScript & TypeScript projects"
  homepage "https://knip.dev/"
  url "https://registry.npmjs.org/knip/-/knip-5.69.0.tgz"
  sha256 "01ef38e8ee100792ebc4debba5535238cd07607cadbe75a375c448bee15bc205"
  license "ISC"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any,                 arm64_tahoe:   "addaf3c9e48bb5f968115a86a4defefb8514356d127176745059dcae0d338035"
    sha256 cellar: :any,                 arm64_sequoia: "5814260befd377f093ea855b7ac886c47449488a59b7c609d8e3bd5faddb9142"
    sha256 cellar: :any,                 arm64_sonoma:  "5814260befd377f093ea855b7ac886c47449488a59b7c609d8e3bd5faddb9142"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ac616b9b14ccb9094c347dcb329a3d782b1d9d46208452af58683f5ebcb21f60"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ad3c829fcb8bb103722630875dab72a94801bba559b6363a7eea27d40f333c7a"
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
