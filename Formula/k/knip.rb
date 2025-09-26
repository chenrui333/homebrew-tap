class Knip < Formula
  desc "Declutter your JavaScript & TypeScript projects"
  homepage "https://knip.dev/"
  url "https://registry.npmjs.org/knip/-/knip-5.64.1.tgz"
  sha256 "b11000e4c1c9fa6245d3a4afbc1ce2b3f9787bd35f29ebccc523bd0c6ff95cab"
  license "ISC"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any,                 arm64_sequoia: "9457994bd10960f32ad1e6bcb89d3a21a9ef4bd3b0170de05f768bcc2a2cdb24"
    sha256 cellar: :any,                 arm64_sonoma:  "2f085eae8642cde0dbfb1814a9e2a0294a126a443a97be7ec3c2b130ff660e4e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "294bd09eef578b46603bdd8a8f8fc511b6db7015bf9ad46fcd6dabbac2be4e63"
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
