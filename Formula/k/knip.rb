class Knip < Formula
  desc "Declutter your JavaScript & TypeScript projects"
  homepage "https://knip.dev/"
  url "https://registry.npmjs.org/knip/-/knip-6.32.2.tgz"
  sha256 "fd0725ff9c6c6ed46f19c5622c89f9ff5eb56ccddeb97f8283ab0bbfa29ae4ad"
  license "ISC"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any,                 arm64_tahoe:   "c632007fedb59183d1362261a9c69f31b5cb1abf6c346fe3f39c3612aad270c7"
    sha256 cellar: :any,                 arm64_sequoia: "c632007fedb59183d1362261a9c69f31b5cb1abf6c346fe3f39c3612aad270c7"
    sha256 cellar: :any,                 arm64_sonoma:  "c632007fedb59183d1362261a9c69f31b5cb1abf6c346fe3f39c3612aad270c7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a10cc60b8422ba62e4577959d4a340d7017ceafc7ad88ea2b23450bace965d27"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "28643a6d58b86aa7f4944ba443f5fecb1198c9ac0583f68928be510caf7d71c9"
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
