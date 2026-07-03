class Knip < Formula
  desc "Declutter your JavaScript & TypeScript projects"
  homepage "https://knip.dev/"
  url "https://registry.npmjs.org/knip/-/knip-6.24.0.tgz"
  sha256 "d6002222ee37761546ae9653bf55ff7c36294aa4900b66661c94225fb9d246c2"
  license "ISC"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any,                 arm64_tahoe:   "cf1ac2d73443d0e122d592b749d086ac4a3f75b4c6bb6eb58d87999b970bd657"
    sha256 cellar: :any,                 arm64_sequoia: "05de359266f34eb429db97638edc38ed9b34f263bbf0438b8ca156af5c534592"
    sha256 cellar: :any,                 arm64_sonoma:  "05de359266f34eb429db97638edc38ed9b34f263bbf0438b8ca156af5c534592"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9fce7c157fea22af5fa251c351bb3f6cf43755d7dc192fa1c89abdcb319a509a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cd0a176b74d226cd5d198ebc6ef52ee954dc4d391ffd690d470d40f6d8f4ade2"
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
