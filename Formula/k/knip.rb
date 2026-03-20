class Knip < Formula
  desc "Declutter your JavaScript & TypeScript projects"
  homepage "https://knip.dev/"
  url "https://registry.npmjs.org/knip/-/knip-6.0.1.tgz"
  sha256 "4566a5c498ac88513509634cc10140d78f503841bda4ba08f5dd4a14a135159a"
  license "ISC"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any,                 arm64_tahoe:   "6f77ba4b250bd7a5fe7fba110e9dc0199a9eebab762b760031035ed4f8633066"
    sha256 cellar: :any,                 arm64_sequoia: "cd7e62b4508e33ebf12e446db8ea57cc2d00db91bb3bd48b6680830cffcc9f4e"
    sha256 cellar: :any,                 arm64_sonoma:  "cd7e62b4508e33ebf12e446db8ea57cc2d00db91bb3bd48b6680830cffcc9f4e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b998444dec290f318f919d416c9363771d53b709f87590dfa4cd6c6885a2cc37"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "aca4bee4ba54a8d2a4fe658ee359cbe63ee6e273c735dbd7b2017b5d075be4d5"
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
