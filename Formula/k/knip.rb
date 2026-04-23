class Knip < Formula
  desc "Declutter your JavaScript & TypeScript projects"
  homepage "https://knip.dev/"
  url "https://registry.npmjs.org/knip/-/knip-6.6.1.tgz"
  sha256 "b534403ebeb1debce731111b7a7703f15ffed35d02a5970a7942c7cc8a12bfd1"
  license "ISC"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any,                 arm64_tahoe:   "9cc8fc2c43cb4a85a6349307766e47553a402de921f55356b79c9f5220354811"
    sha256 cellar: :any,                 arm64_sequoia: "4fd2e2f3e830edf4fbc1dba8774fd0da610a1df99fe64eecbcefaab38cccf89e"
    sha256 cellar: :any,                 arm64_sonoma:  "4fd2e2f3e830edf4fbc1dba8774fd0da610a1df99fe64eecbcefaab38cccf89e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d982d58e77aee42f825828994196cb6604cd21553178766c6b4cf2a9fc406350"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e1bcae4881ba79f68a77309b1eaf5cb74b54cf9a8cca1fbb310452468a179e09"
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
