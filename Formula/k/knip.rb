class Knip < Formula
  desc "Declutter your JavaScript & TypeScript projects"
  homepage "https://knip.dev/"
  url "https://registry.npmjs.org/knip/-/knip-6.46.0.tgz"
  sha256 "00991297eac7526a208c479a1fa79dd20a609c625a6544f2c0968ef94e452013"
  license "ISC"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any,                 arm64_tahoe:   "01f86f4683ad471b64cba853aa1f22954bf16e65ea5c4bf5036b7595115c2336"
    sha256 cellar: :any,                 arm64_sequoia: "01f86f4683ad471b64cba853aa1f22954bf16e65ea5c4bf5036b7595115c2336"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5380be728f656df8c7ecd75dc42634e06bbcd8b4dabddee6a9990dca445ed538"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "000d19d319ce483d65a87cd678a3cbf87c672502a275e81f2b76e2ee4aed3491"
  end

  depends_on "node"

  deny_network_access!

  def fetch
    system "npm", "install", *std_npm_args(prefix: buildpath/"npm-fetch")
  end

  def install
    system "npm", "install", "--offline", *std_npm_args
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
