class Knip < Formula
  desc "Declutter your JavaScript & TypeScript projects"
  homepage "https://knip.dev/"
  url "https://registry.npmjs.org/knip/-/knip-5.70.0.tgz"
  sha256 "236728f00c14a1011ae12129c3d03df3044ebc4884dc543b3dc60274d2fb3ef0"
  license "ISC"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any,                 arm64_tahoe:   "a8f6d0547842f5974bddc384ed3c0c01f5d86091341a3fe91beb20937fc1662e"
    sha256 cellar: :any,                 arm64_sequoia: "e90f33c6531863278031bc875250b557324384160b35e4610c12add0f61fb453"
    sha256 cellar: :any,                 arm64_sonoma:  "e90f33c6531863278031bc875250b557324384160b35e4610c12add0f61fb453"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "84b94d6765f276f4bd0e9d27550a8d850a9d905f771edc1f482ff827c904f0f7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c397a8bb69dfc9790de54403dc3f4190200475c6f37b264b634b9d43d0b945f8"
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
