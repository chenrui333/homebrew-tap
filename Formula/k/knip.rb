class Knip < Formula
  desc "Declutter your JavaScript & TypeScript projects"
  homepage "https://knip.dev/"
  url "https://registry.npmjs.org/knip/-/knip-6.39.0.tgz"
  sha256 "eda83ec20de855acedf000f9259cba17219d4a290a2644d3e685c24f42f22f83"
  license "ISC"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    rebuild 1
    sha256 cellar: :any,                 arm64_tahoe:   "d41d0974832aaaca863ea2fded1cf0fba2b7a0e107e38499efbd08b40cbbddce"
    sha256 cellar: :any,                 arm64_sequoia: "d41d0974832aaaca863ea2fded1cf0fba2b7a0e107e38499efbd08b40cbbddce"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3f91cb462de37113996214e05ed1528b59a235227d22881f8aead23905d280cd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "23a316555723082f0ab3fc9e6a8e5b0f0a5e1c2bfb0a6f757387bb0595083a6d"
  end

  depends_on "node"

  deny_network_access!

  def fetch
    system "npm", "install", *std_npm_args(prefix: buildpath/"npm-fetch")
  end

  def install
    system "npm", "install", "--offline", *std_npm_args
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
