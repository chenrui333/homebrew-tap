class Knip < Formula
  desc "Declutter your JavaScript & TypeScript projects"
  homepage "https://knip.dev/"
  url "https://registry.npmjs.org/knip/-/knip-6.3.1.tgz"
  sha256 "d1e1dfec392dbc747620b68fe414f440e411bd6f9813809e6aa21908aae3c2ec"
  license "ISC"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any,                 arm64_tahoe:   "5b981fe3e98b4f0507502c101285918ad3876c21fc9c1c0b21901b3c0d4dafc3"
    sha256 cellar: :any,                 arm64_sequoia: "e89de796cc79440beb3ab1a5572275672b6ab94b0c8a2269a2e8177d109c9d17"
    sha256 cellar: :any,                 arm64_sonoma:  "e89de796cc79440beb3ab1a5572275672b6ab94b0c8a2269a2e8177d109c9d17"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "fc8dcc364a9882668d971fff0833f82a2736eb91153e817ed6641e1e29af0f69"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b50371c7a1d1cfb0526bdb895dc7ba37d393b673eb98935cb8b839789a6950ed"
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
