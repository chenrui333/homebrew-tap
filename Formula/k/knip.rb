class Knip < Formula
  desc "Declutter your JavaScript & TypeScript projects"
  homepage "https://knip.dev/"
  url "https://registry.npmjs.org/knip/-/knip-6.32.3.tgz"
  sha256 "1db176b788738965a7e852da0beb412e6282283974d2c06b42db8f9109669276"
  license "ISC"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any,                 arm64_tahoe:   "e13bddc826333579a336034f04efb9515dbc57d340dfd1dd98b5c0e501507063"
    sha256 cellar: :any,                 arm64_sequoia: "e13bddc826333579a336034f04efb9515dbc57d340dfd1dd98b5c0e501507063"
    sha256 cellar: :any,                 arm64_sonoma:  "e13bddc826333579a336034f04efb9515dbc57d340dfd1dd98b5c0e501507063"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9d24d65b256124e2c56f647f6db38b00df66ad86f9b5307d7bf79310b6ca3891"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "127e02a0ab4a256294beee5dc7b5c19e28f9b9c71135b11bf7080284bfb143eb"
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
