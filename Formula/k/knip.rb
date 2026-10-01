class Knip < Formula
  desc "Declutter your JavaScript & TypeScript projects"
  homepage "https://knip.dev/"
  url "https://registry.npmjs.org/knip/-/knip-6.39.0.tgz"
  sha256 "eda83ec20de855acedf000f9259cba17219d4a290a2644d3e685c24f42f22f83"
  license "ISC"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any,                 arm64_tahoe:   "deee1cca181ddb0a674c8fe3209d99ec2cfb01eb025255a97b71e9030384f1cf"
    sha256 cellar: :any,                 arm64_sequoia: "deee1cca181ddb0a674c8fe3209d99ec2cfb01eb025255a97b71e9030384f1cf"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f0ea0d687d758c830961731d05b5fb4aa952f4d183002cb821702c46a823a694"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ae1adef895b8b9052b6691a3d7def5765fd7be382e9ef2f58ef353813be8912a"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
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
