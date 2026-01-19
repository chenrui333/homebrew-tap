class Knip < Formula
  desc "Declutter your JavaScript & TypeScript projects"
  homepage "https://knip.dev/"
  url "https://registry.npmjs.org/knip/-/knip-5.82.1.tgz"
  sha256 "034b0e799e74e1c5059a25f15d14613031a250a29a46ea21e99a5eeee5439f39"
  license "ISC"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any,                 arm64_tahoe:   "2a370b97e9f447b7d159f8e3e82f79ce061a475edb3a5ee0f810c06aa234b459"
    sha256 cellar: :any,                 arm64_sequoia: "f0aa29bf703d3c7c20290ed09b19fc6978c901977fae006a31e1974b4ae7a8ba"
    sha256 cellar: :any,                 arm64_sonoma:  "f0aa29bf703d3c7c20290ed09b19fc6978c901977fae006a31e1974b4ae7a8ba"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "467fd0e72eb35c6fd978baa140e57c6ba140afe504cec88a580856db58c7c63f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "89b7f9bdee53588530f3a7fa049a89ed9f6dd7b64845d9ec94a8c9f51402eaf3"
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
