class Knip < Formula
  desc "Declutter your JavaScript & TypeScript projects"
  homepage "https://knip.dev/"
  url "https://registry.npmjs.org/knip/-/knip-5.55.0.tgz"
  sha256 "2f5bf71d939e81f913ffa97f020b3cde025fa4774edf25cec6352f32ce29b80c"
  license "ISC"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7b129542be74b4a58060eeff08753b1e19a46a686853c8d9153e3e0eb62b036c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8425f6cf7023f2e718d18273fa011b970f60d0861895a35796282f4c3e876b3d"
    sha256 cellar: :any_skip_relocation, ventura:       "6507d0e111c621f8bd9c14961756bb59d0168996386c768f7569d01466294867"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d7defd101091c06fdfd90b7bb1401064ff9390ca75a214873478227c0b6b37f9"
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
