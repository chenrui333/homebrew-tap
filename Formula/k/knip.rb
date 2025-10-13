class Knip < Formula
  desc "Declutter your JavaScript & TypeScript projects"
  homepage "https://knip.dev/"
  url "https://registry.npmjs.org/knip/-/knip-5.65.0.tgz"
  sha256 "54b26c3ba9a90a8b3435e07fbad29269c689d7ac98b2b0f14b08c0f558a406cc"
  license "ISC"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any,                 arm64_tahoe:   "423e5586e715531c3dcdbfa1d538af12a7342d31f86907a909d4e4d03b4764a1"
    sha256 cellar: :any,                 arm64_sequoia: "1630cea04fc1330eb7bb525608fd460b49c6c7ddb55233e47f22fdbb8d0fa898"
    sha256 cellar: :any,                 arm64_sonoma:  "1630cea04fc1330eb7bb525608fd460b49c6c7ddb55233e47f22fdbb8d0fa898"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "51cc836113bb292a926dc7ae2306232ed4e1f63de74d40a78deacfa2b0e71720"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "962d528fdbbd9f3dac2b45472ef6df99801d9119e8507ff59c37a499f72d53c5"
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
