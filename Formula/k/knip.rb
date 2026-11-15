class Knip < Formula
  desc "Declutter your JavaScript & TypeScript projects"
  homepage "https://knip.dev/"
  url "https://registry.npmjs.org/knip/-/knip-6.45.0.tgz"
  sha256 "aeb34d27cc26d59eb2624fa9b570a7eaee9b63c4e6ef4e74b0724b69ed5d9b74"
  license "ISC"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any,                 arm64_tahoe:   "c8f5d3f7ded4cf0882b44e8663a428943c13ba8b7a6c7889b7445fb5583df599"
    sha256 cellar: :any,                 arm64_sequoia: "c8f5d3f7ded4cf0882b44e8663a428943c13ba8b7a6c7889b7445fb5583df599"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9a8f8d3787f7ca3c0cd25f8229f11fe2fa23a5c62b4e7ac40bd388d5e1660a61"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2736db24d2983bd4de0bfaad0d46f68a06bebd8f16df46d8e5886fbfad3bacf4"
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
