class Knip < Formula
  desc "Declutter your JavaScript & TypeScript projects"
  homepage "https://knip.dev/"
  url "https://registry.npmjs.org/knip/-/knip-6.0.4.tgz"
  sha256 "81c1e70adcbf068130dda380d1bfe0a2931f3d8b017b250e4e070de4b5c4e33a"
  license "ISC"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any,                 arm64_tahoe:   "f8f9fa9881cdf1d331edb1a29afdfd2fec3928de60205ba908032b19b65ad15f"
    sha256 cellar: :any,                 arm64_sequoia: "bbb81568fbb2ac2f7e6f8edfbcd9e53f630f4343001003cbc9e478970230d757"
    sha256 cellar: :any,                 arm64_sonoma:  "bbb81568fbb2ac2f7e6f8edfbcd9e53f630f4343001003cbc9e478970230d757"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2d9e19b29e129caa83154f99c305b1f677c8638dedf0127e7ac32b90aeee105f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f78057b1ed760b42ab40263804e0be37a7a14bae2bacb6e2e5428abdbe9a158c"
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
