class Knip < Formula
  desc "Declutter your JavaScript & TypeScript projects"
  homepage "https://knip.dev/"
  url "https://registry.npmjs.org/knip/-/knip-5.63.0.tgz"
  sha256 "a7c598853437e131a60450caa06b6bcd1267251cb1bfa26baf3ad5663baa8915"
  license "ISC"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any,                 arm64_sequoia: "8e90d81c2ec84a1e30e6edd50e067ab2c014168c660d8e41c94ec537e162a2ee"
    sha256 cellar: :any,                 arm64_sonoma:  "af0f2f77f2ae0ab27ae4a07d39c5554215dfb960fc90321001eb6f720d054919"
    sha256 cellar: :any,                 ventura:       "424ef10a4518f7e3bbc0d95c2c0c12d83f237e31620cb4bd9cb353713d15b7ec"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "96f5421618a4e63420fd3598873b2a1a0d466e6a124f0c2a675083f7c8728fc4"
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
