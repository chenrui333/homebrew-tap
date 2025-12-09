class Knip < Formula
  desc "Declutter your JavaScript & TypeScript projects"
  homepage "https://knip.dev/"
  url "https://registry.npmjs.org/knip/-/knip-5.73.0.tgz"
  sha256 "363a5c8e7e9de49b6fc62d295f8931722a4a8a741096ee08794a185a928fd24b"
  license "ISC"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any,                 arm64_tahoe:   "8794c6573c9c88c1cb49bf98a199959e4fdb2f227de3d1eaa5b6920d69361e6b"
    sha256 cellar: :any,                 arm64_sequoia: "75d5cc3b8001e869d9e8cc25d11071e23bb587ff37245acd32e923ecad0c6b25"
    sha256 cellar: :any,                 arm64_sonoma:  "75d5cc3b8001e869d9e8cc25d11071e23bb587ff37245acd32e923ecad0c6b25"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "526eac6f4eb904fc3bbb2db11e1b56912b0312ccb0ee4982dcaab8cb4c3151e9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8238e84347df33d905051562f638878fdabeea23fde6ac3b6c061fd7cdfde51f"
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
