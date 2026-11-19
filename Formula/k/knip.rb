class Knip < Formula
  desc "Declutter your JavaScript & TypeScript projects"
  homepage "https://knip.dev/"
  url "https://registry.npmjs.org/knip/-/knip-6.46.0.tgz"
  sha256 "00991297eac7526a208c479a1fa79dd20a609c625a6544f2c0968ef94e452013"
  license "ISC"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any,                 arm64_tahoe:   "b8b8c914354031a975934fa6bcc8c7ccfb9775e473ad05ca09f2caebf4b73248"
    sha256 cellar: :any,                 arm64_sequoia: "b8b8c914354031a975934fa6bcc8c7ccfb9775e473ad05ca09f2caebf4b73248"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d4bcf387bb9c208600f8d6c2ff94eef2b6c5073beff7cc42e8e9d2979892c8ec"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "262d6686b0b6356794ef967d97cb91c40a92cfe8dc30b5a69006522f4528c2ab"
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
