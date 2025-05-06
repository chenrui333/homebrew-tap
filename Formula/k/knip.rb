class Knip < Formula
  desc "Declutter your JavaScript & TypeScript projects"
  homepage "https://knip.dev/"
  url "https://registry.npmjs.org/knip/-/knip-5.54.0.tgz"
  sha256 "9dafd14a5213a7c4025ed71b1c301173e46827e96a574a30c8a9799abe96b556"
  license "ISC"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9b40a0c401bc769c523b80b2fff9acd227dd1f2e470c84d43183f95dfec81bf7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8b0e155dbcb07519ea21dc8dac200c3bf1160c62d719fd5f679b246a1eb48b47"
    sha256 cellar: :any_skip_relocation, ventura:       "3b022ed3e4dbaa931bc085824bc20264b87a997e04c7811058d4514ce0b0d2f0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6ad972a67a1740cec7245e0c43b56f5f0b766fc81fb9622e760ac6ab0ffc7f7c"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/knip --version")

    (testpath/"package.json").write <<~JSON
      {
        "name": "my-project",
        "scripts": {
          "knip": "knip"
        }
      }
    JSON

    system bin/"knip", "--production"
  end
end
