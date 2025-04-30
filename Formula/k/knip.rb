class Knip < Formula
  desc "Declutter your JavaScript & TypeScript projects"
  homepage "https://knip.dev/"
  url "https://registry.npmjs.org/knip/-/knip-5.51.1.tgz"
  sha256 "d5aefec9e93aa19555e80df84de6a041a681241209d4e47e2e5fb9a274ff83b8"
  license "ISC"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "086ee574ed984738db1584f9fa6e2fdd679d403c69013cdd4ec71fa00957269e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0845c407470e21b3ba157067fc12710dcbf85d060c6b5995daf73297e3359b0e"
    sha256 cellar: :any_skip_relocation, ventura:       "7489d603f256ec0b0121b87e3bcba2b20035a252ea7ebb53c22a51da76b03f2f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b92d3301d1cbe6175ae72fab5a53bc8c853cc4612aeb5759987b5393b54fb291"
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
