class Knip < Formula
  desc "Declutter your JavaScript & TypeScript projects"
  homepage "https://knip.dev/"
  url "https://registry.npmjs.org/knip/-/knip-5.62.0.tgz"
  sha256 "1f71372490430926931b27932256ded47538fd74e33576b66cfac2f2994edc20"
  license "ISC"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any,                 arm64_sequoia: "5467d3730ae10e22625325f7eb8bebf78255bfaa4d783a535ffc33a7c4858159"
    sha256 cellar: :any,                 arm64_sonoma:  "65433ad12fcdec388411de647f518778be59f4fcab03a6b5649311d935996cf4"
    sha256 cellar: :any,                 ventura:       "05924c54b19a249285a8d71b6a0d684d1334985ec5907598908b199671d2517d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9707d27a801d81151d3a0f34a79c9c422f48b16aba52f18774558ebbf5b7c0f0"
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
