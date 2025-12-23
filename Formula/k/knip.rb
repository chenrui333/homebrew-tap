class Knip < Formula
  desc "Declutter your JavaScript & TypeScript projects"
  homepage "https://knip.dev/"
  url "https://registry.npmjs.org/knip/-/knip-5.77.0.tgz"
  sha256 "f603deac5a5ee4bc1a54b39b4d3f69bf7b5cf8e823f6a5226753e1835981e82e"
  license "ISC"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any,                 arm64_tahoe:   "8901e3149dce5c9184f8cf2c931696e30d34be3fcc617bbbd272c627a060c209"
    sha256 cellar: :any,                 arm64_sequoia: "34b8d7a2afa9703e779bd69029cd8ec4ecaad4cd4aaa61d380bb49bc7b6b15eb"
    sha256 cellar: :any,                 arm64_sonoma:  "34b8d7a2afa9703e779bd69029cd8ec4ecaad4cd4aaa61d380bb49bc7b6b15eb"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ce09ff43f1d8e4c49e0aa1e2ed787197572257993b24c5a8ae50fd9c5ab61780"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a8ef4c6221d512c5f454d0b0c874045d905bfc591288a5b4e380f9c38f7e5f58"
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
