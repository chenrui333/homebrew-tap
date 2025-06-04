class Knip < Formula
  desc "Declutter your JavaScript & TypeScript projects"
  homepage "https://knip.dev/"
  url "https://registry.npmjs.org/knip/-/knip-5.60.0.tgz"
  sha256 "ab42948b5636f3f5f2c00a7d74c0af9cb7dc45e4521166ac30ec4a3920dcf9a2"
  license "ISC"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any,                 arm64_sequoia: "2ac108c12f0e91af9406a1dc8b91c8c06dada5ea60bf6c65411050c910a1ed6b"
    sha256 cellar: :any,                 arm64_sonoma:  "a6fbe593a235563f5056bdecc2283edaf6a0c2f6156f7dc864e2185cd46eff7c"
    sha256 cellar: :any,                 ventura:       "8c9f66ed7f011b27728078fcd465114f5a9dcedcc0de895dcb01b40557da8f7b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f630c6418e89920fe2c9cc887363910aea99404c8f4572520c03c5cf7f5a2afe"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/knip --version")

    (testpath/"package.json").write <<~JSON
      {
        "name": "my-project",
        "scripts": {
          "knip": "knip"
        }
      }
    JSON

    system bin/"knip", "--production"
  end
end
