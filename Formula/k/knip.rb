class Knip < Formula
  desc "Declutter your JavaScript & TypeScript projects"
  homepage "https://knip.dev/"
  url "https://registry.npmjs.org/knip/-/knip-6.0.5.tgz"
  sha256 "7b3d32cdaa420db3c5465d0d8a3e412a5587ac3a2389616baf8c0ec6a33e4b75"
  license "ISC"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any,                 arm64_tahoe:   "050359c85aa15dcd0b6f6e91ccdca3529f1581f27ea70c63b454a347f2a05099"
    sha256 cellar: :any,                 arm64_sequoia: "b651b0874155d4e1cde485eff1c000d5890cf61bda758abe1952d5cdf8759fd7"
    sha256 cellar: :any,                 arm64_sonoma:  "b651b0874155d4e1cde485eff1c000d5890cf61bda758abe1952d5cdf8759fd7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "741828b2db686e706d019e2672249f50f066ff9c31f73852149852e34693022e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ef6be099c9fdbf8e5c2ff3e9b643136df448f5ac895cea8f9593e98cb39754bb"
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
