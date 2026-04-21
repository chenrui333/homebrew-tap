class Knip < Formula
  desc "Declutter your JavaScript & TypeScript projects"
  homepage "https://knip.dev/"
  url "https://registry.npmjs.org/knip/-/knip-6.5.0.tgz"
  sha256 "28f6cc3f226d6aefb30709b97138721a183074880b02ebde53ff1abc5e577b94"
  license "ISC"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any,                 arm64_tahoe:   "6162ef9c92c1ae79203d74cd5f2c5c34d018fbfb8762b910e82ae6b8f4f0f84f"
    sha256 cellar: :any,                 arm64_sequoia: "026f8d3417e7c4c10b599c42e224a7a9d4409c22c11b4baa2fd53a1f9e0366ba"
    sha256 cellar: :any,                 arm64_sonoma:  "026f8d3417e7c4c10b599c42e224a7a9d4409c22c11b4baa2fd53a1f9e0366ba"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "00076201e7f2b5599526feee8f82a450c73b9c9db7ed814445510f11b850658f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9b41a3db865cfa9bba6a5df382a6da66e0abc2e7b5ab39aa063ae9e7387845fe"
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
