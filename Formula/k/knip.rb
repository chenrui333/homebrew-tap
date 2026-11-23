class Knip < Formula
  desc "Declutter your JavaScript & TypeScript projects"
  homepage "https://knip.dev/"
  url "https://registry.npmjs.org/knip/-/knip-6.48.0.tgz"
  sha256 "3f13c23f7f80ed6e60e953e1921fe6f6099929d167145c211382f8a335fd3755"
  license "ISC"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    manifest_sha256 "0df2f104955e8ab26428934f7c61dda20c4fef84ff9d8890d0df42e9723472e9"
    sha256 cellar: :any,                 arm64_tahoe:   "12e59b5079d2a58b802f480993e5023510f8a26a2f0ea5c64817b171b5df920f"
    sha256 cellar: :any,                 arm64_sequoia: "12e59b5079d2a58b802f480993e5023510f8a26a2f0ea5c64817b171b5df920f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b172e25d9bb998ddf3841770bddb2eb49b08515468c8d5d1b451eb0b847957ca"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "12fb9caa16f157133fa713400a37138fc4a19488a5ec99a1e31d06139d179de6"
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
