class Knip < Formula
  desc "Declutter your JavaScript & TypeScript projects"
  homepage "https://knip.dev/"
  url "https://registry.npmjs.org/knip/-/knip-6.12.1.tgz"
  sha256 "85be4312bfc6025bae54a21b632366701fdb595e61b0b0faaba9ed26c1b83492"
  license "ISC"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any,                 arm64_tahoe:   "a12c4587b97cc2223f6ac331e64d8525af8a7212fb9ac68c6c5076300189f2ca"
    sha256 cellar: :any,                 arm64_sequoia: "8996c60a0a5d0ed7fc87a9e907d5ee722900961353af223e28560140b22404c0"
    sha256 cellar: :any,                 arm64_sonoma:  "8996c60a0a5d0ed7fc87a9e907d5ee722900961353af223e28560140b22404c0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "da770d0ef1a7469d1af72e0b1ab18ec261c338b4629c75dc91ae9b222ddb92f1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f3f0292a184b601f9e65646c95099e6d62eb95847264d4c2f6c992ceffea842a"
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
