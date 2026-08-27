class Knip < Formula
  desc "Declutter your JavaScript & TypeScript projects"
  homepage "https://knip.dev/"
  url "https://registry.npmjs.org/knip/-/knip-6.32.3.tgz"
  sha256 "1db176b788738965a7e852da0beb412e6282283974d2c06b42db8f9109669276"
  license "ISC"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any,                 arm64_tahoe:   "73bef90acc7d6862b84ffb0165575f07b8b545d122aeea773ef3ae5a935e9380"
    sha256 cellar: :any,                 arm64_sequoia: "73bef90acc7d6862b84ffb0165575f07b8b545d122aeea773ef3ae5a935e9380"
    sha256 cellar: :any,                 arm64_sonoma:  "73bef90acc7d6862b84ffb0165575f07b8b545d122aeea773ef3ae5a935e9380"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "724a92ebbf068d324fec5ce11dc2c6d3b38431fa5e0342fd4684eb82a4c65bbe"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9fb191e9bac8fcdeabcdd7cd0fa02d64a52754ef2dddf0d2b65781581907b5bd"
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
