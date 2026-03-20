class Knip < Formula
  desc "Declutter your JavaScript & TypeScript projects"
  homepage "https://knip.dev/"
  url "https://registry.npmjs.org/knip/-/knip-6.0.1.tgz"
  sha256 "4566a5c498ac88513509634cc10140d78f503841bda4ba08f5dd4a14a135159a"
  license "ISC"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any,                 arm64_tahoe:   "e97baad4d88e035234abdaa668b07b7a082bd8e40fe40a427d13570b586047db"
    sha256 cellar: :any,                 arm64_sequoia: "67d20ba6ddfdf48b7f310010d85b7704f35347ef335991bc221cc99bb6802bbd"
    sha256 cellar: :any,                 arm64_sonoma:  "67d20ba6ddfdf48b7f310010d85b7704f35347ef335991bc221cc99bb6802bbd"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "208c93a4a4d9c74582264499663fe2ef7132ff368331042d9f036a2489119aea"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "19d2f6f760cb41613fe0bd2e1b45a93e7b3b41bcca1e4178ed9123ffeb83294e"
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
