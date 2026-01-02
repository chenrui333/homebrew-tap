class Knip < Formula
  desc "Declutter your JavaScript & TypeScript projects"
  homepage "https://knip.dev/"
  url "https://registry.npmjs.org/knip/-/knip-5.79.0.tgz"
  sha256 "f0795f253219640e486bbdb3636006d84f10c44d385bafe0a7c15e08101a3a33"
  license "ISC"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any,                 arm64_tahoe:   "6c6b0a8ed5e44db2d5bb52f95f4e29026663b8493108aa0461a85fab24888710"
    sha256 cellar: :any,                 arm64_sequoia: "560f25a152eb60d39e1a53d488f91d39cd14f1bd9e0d5ab4c6b471f2fbca1ac1"
    sha256 cellar: :any,                 arm64_sonoma:  "560f25a152eb60d39e1a53d488f91d39cd14f1bd9e0d5ab4c6b471f2fbca1ac1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b1f11b13e68a6445b0b77b6172f9511e97782eb5ec7f2d78ad2824875a07f38e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bc974f89f696729dee794d25ecb72d07ce35c89748a884c53fe4a55525ff1b39"
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
