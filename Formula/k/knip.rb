class Knip < Formula
  desc "Declutter your JavaScript & TypeScript projects"
  homepage "https://knip.dev/"
  url "https://registry.npmjs.org/knip/-/knip-6.13.0.tgz"
  sha256 "9f479896f6b6d7160bdb0c460cb874349879e466b8e674897897222a1a504023"
  license "ISC"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any,                 arm64_tahoe:   "e4eac55fb017a8c729a0567a6f44ed5fc166dc9afeae7b14b6d308a45e85c2d0"
    sha256 cellar: :any,                 arm64_sequoia: "c4d441ba0aec349d1605b4813c8ffc2d14c7d13346ec5a2192be4fc8869ac20a"
    sha256 cellar: :any,                 arm64_sonoma:  "c4d441ba0aec349d1605b4813c8ffc2d14c7d13346ec5a2192be4fc8869ac20a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "fcd278951c5e64d8208efbc2376d253591eea7b7940ce5d66e7d3d8e8d5cfbf6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4e6edd91c01d8ae74efad9b75bd8d784da769ca4999143be958e8199ea93fcea"
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
