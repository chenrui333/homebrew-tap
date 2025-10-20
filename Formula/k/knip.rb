class Knip < Formula
  desc "Declutter your JavaScript & TypeScript projects"
  homepage "https://knip.dev/"
  url "https://registry.npmjs.org/knip/-/knip-5.66.2.tgz"
  sha256 "9bad92ec09a35a5753de3474a1381d87522e2c1aeaad3508c179e766e8327501"
  license "ISC"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any,                 arm64_tahoe:   "5d823323c154747d1303bda91868759dc5cc7e90313dcb3c743555f32e452887"
    sha256 cellar: :any,                 arm64_sequoia: "a3c0ea04c64dc903d0ab7537071020900535f4720704dc8b18ebf1a71b9de628"
    sha256 cellar: :any,                 arm64_sonoma:  "a3c0ea04c64dc903d0ab7537071020900535f4720704dc8b18ebf1a71b9de628"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ebdb0f9dcdca31932fc9ab58dd4e207ae5d8394ee3619f1ffeacbb4840cc7579"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ea95d08d58cebb7cafc73ea37eadfbf39175ef20dce3d527243dc21886facc0f"
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
