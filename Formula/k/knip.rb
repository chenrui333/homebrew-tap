class Knip < Formula
  desc "Declutter your JavaScript & TypeScript projects"
  homepage "https://knip.dev/"
  url "https://registry.npmjs.org/knip/-/knip-6.16.1.tgz"
  sha256 "5c2cd307566b3e46934f614d94b99dd3e7cdb3591d76042af0dcb25657cfe9a0"
  license "ISC"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any,                 arm64_tahoe:   "e26ee1bc0542390808d3370930e69b90125439e9a340b92f29fc8cfe9df4395c"
    sha256 cellar: :any,                 arm64_sequoia: "f14ff8fcb6e2a0d8dbd9c8b45af3b1911be28a2f954991fbeb9480b440905aa0"
    sha256 cellar: :any,                 arm64_sonoma:  "f14ff8fcb6e2a0d8dbd9c8b45af3b1911be28a2f954991fbeb9480b440905aa0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "01c2de94dbd2a19efd30cf5f7d51f300f34130a20780650b39a395cc4d8b13b7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f94a4c1402d4dbd16e5cbda296e160a6b7a864bf54a85fd3d23cce24f8e232ea"
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
