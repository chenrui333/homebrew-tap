class Knip < Formula
  desc "Declutter your JavaScript & TypeScript projects"
  homepage "https://knip.dev/"
  url "https://registry.npmjs.org/knip/-/knip-6.2.0.tgz"
  sha256 "037610fd1c3017cfaa42cccbd713faf62d750f5e54990fa1844425c19de6c0eb"
  license "ISC"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any,                 arm64_tahoe:   "1edd1fcc69d4c5182b11b848049ed40c63f20211aa44ce2a0586e6b7afdd16a1"
    sha256 cellar: :any,                 arm64_sequoia: "d8e1510bc9053f4fd6697ffda745353ba54811bf1eb739eba5cb354aaa499173"
    sha256 cellar: :any,                 arm64_sonoma:  "d8e1510bc9053f4fd6697ffda745353ba54811bf1eb739eba5cb354aaa499173"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6107c56813f2ba4083452bd4d3eed70394f73052ed715e3f082e14a7ea13280b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bf90fecbfa465e8e72f773f2aa1fb251fef6f5c45bd6c7c59a93fe22dbff8a6e"
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
