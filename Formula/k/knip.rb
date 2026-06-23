class Knip < Formula
  desc "Declutter your JavaScript & TypeScript projects"
  homepage "https://knip.dev/"
  url "https://registry.npmjs.org/knip/-/knip-6.17.2.tgz"
  sha256 "4aba535d59d0892de50b5701534ce3d0c2c74520caf3ff4f69b48ccac79831d8"
  license "ISC"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any,                 arm64_tahoe:   "50c37f375c96f77efa407298b75465747a8f5a2c1876a368cd77b2f1977d684a"
    sha256 cellar: :any,                 arm64_sequoia: "dc9c983cb93ab5a74dd3363256bcfd6002988b885bd9fafb35a8cd3762586fe2"
    sha256 cellar: :any,                 arm64_sonoma:  "dc9c983cb93ab5a74dd3363256bcfd6002988b885bd9fafb35a8cd3762586fe2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9717bb4663091cc50b7db4b39ea895d66623b9070ea986efd71fde12489093fe"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "83d2143b588be766ca93ee6ccd21a78f6d8a4a477f1ebd3b2c5c8aa9b03ac939"
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
