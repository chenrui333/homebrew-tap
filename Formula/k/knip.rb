class Knip < Formula
  desc "Declutter your JavaScript & TypeScript projects"
  homepage "https://knip.dev/"
  url "https://registry.npmjs.org/knip/-/knip-5.64.3.tgz"
  sha256 "4f69e0e17c39eeae86f0379e504cfd15455769233da9ac67410fc79e065aab6d"
  license "ISC"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any,                 arm64_tahoe:   "6a74379866451f3e95057120aeba8420d5c691a8c565b607d74f69861dcb1947"
    sha256 cellar: :any,                 arm64_sequoia: "a58f1adb2cb3fdcc7d0b08aa70fc01812380bb9c4d5e40eac24454149c3c7125"
    sha256 cellar: :any,                 arm64_sonoma:  "abd126204484b4d7f5b880b51aa9431251bbeea0095f06eafdc5d1dd99b5ffdd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "870c0f2940a18bf8c37d3ed841a060aabb1836a491b1519181a81740ca225c9f"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
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
