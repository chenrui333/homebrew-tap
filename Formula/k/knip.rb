class Knip < Formula
  desc "Declutter your JavaScript & TypeScript projects"
  homepage "https://knip.dev/"
  url "https://registry.npmjs.org/knip/-/knip-6.43.0.tgz"
  sha256 "ea3cbb5ef5a30ca2ea221f84f077dea98953487d748225bbacc4c8c18ad3caf1"
  license "ISC"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any,                 arm64_tahoe:   "e6b3c97942b9d97e30830f4ea44d8eeb8a58887568a4bb39f6b7bc34eae1cabd"
    sha256 cellar: :any,                 arm64_sequoia: "e6b3c97942b9d97e30830f4ea44d8eeb8a58887568a4bb39f6b7bc34eae1cabd"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ffdf11d4b1f356f8089096368ecfb69a89b54e10871cb2f7591d103af92060e6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "01f16ad37c13d28ec6bf050576b3d5ad63ccca7f355eaab040aef0851b9fb836"
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
