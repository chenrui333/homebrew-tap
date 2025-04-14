class Knip < Formula
  desc "Declutter your JavaScript & TypeScript projects"
  homepage "https://knip.dev/"
  url "https://registry.npmjs.org/knip/-/knip-5.50.3.tgz"
  sha256 "4ef7d773d6876c724992012a2b46475d51e0ad4135f2f5c3fde429065b5769c8"
  license "ISC"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7134f07a948f5e91cfc2b08592c10cd9e856aa7ce5df303178da08b0f6a4d298"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f28fa448bc4a29b7ff37117441a54ce31ef526239d14701d2b31c56504b0e94b"
    sha256 cellar: :any_skip_relocation, ventura:       "987ba7c4ea79ab75153d571a80b76f00f6673a8420893b6f0a422bc304043932"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3ef1e8488f1875045b9453a3cea5bb5f5a3b2c34c2d767f59fe98fffb5da2756"
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
