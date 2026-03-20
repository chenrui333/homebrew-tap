class Knip < Formula
  desc "Declutter your JavaScript & TypeScript projects"
  homepage "https://knip.dev/"
  url "https://registry.npmjs.org/knip/-/knip-6.0.0.tgz"
  sha256 "288ba2fc4eac2b7a314c74a3a96e251b781441daf7bea430f2ab0b8de041a4c7"
  license "ISC"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any,                 arm64_tahoe:   "cd43b4e970d0221142d9229b0867493a296db95e6e9faaf999c063ef13e39115"
    sha256 cellar: :any,                 arm64_sequoia: "2f803d92688f11c45dbfb45a47865773d8cc4092e943d4163a3fae2cd7b363c3"
    sha256 cellar: :any,                 arm64_sonoma:  "2f803d92688f11c45dbfb45a47865773d8cc4092e943d4163a3fae2cd7b363c3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3ec2f43e7e68a1eb0a7ff08b42829f878822f5ef103824ea7dd9871b62bdf8e8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0a2a2ec72f45aa033b270273f58a0372147580428bd12651ab39b237cc441539"
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
