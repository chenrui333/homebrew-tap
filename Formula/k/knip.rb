class Knip < Formula
  desc "Declutter your JavaScript & TypeScript projects"
  homepage "https://knip.dev/"
  url "https://registry.npmjs.org/knip/-/knip-6.12.2.tgz"
  sha256 "f175ad8416084220444c3ca80303d9ed98785f85330f98a762ff31d3f96b4d60"
  license "ISC"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any,                 arm64_tahoe:   "b9c6cadc5fb2f4d5f73b25262f0146f8f8a00020690b9faeb168d92500e53a3b"
    sha256 cellar: :any,                 arm64_sequoia: "ac4b08747ed7acc72019cc0febdd30a22120cd8545e0829c98f09de896c2dc78"
    sha256 cellar: :any,                 arm64_sonoma:  "ac4b08747ed7acc72019cc0febdd30a22120cd8545e0829c98f09de896c2dc78"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "da07fd318932b6ce7bef13a62e54368c4df1139d3434ebdcc3ac32a0537f6df8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "06aebf9410456603fed2e70b5cc7c96dc5d37e142b64eac4678dd5debad05c67"
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
