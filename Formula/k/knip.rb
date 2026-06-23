class Knip < Formula
  desc "Declutter your JavaScript & TypeScript projects"
  homepage "https://knip.dev/"
  url "https://registry.npmjs.org/knip/-/knip-6.17.2.tgz"
  sha256 "4aba535d59d0892de50b5701534ce3d0c2c74520caf3ff4f69b48ccac79831d8"
  license "ISC"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any,                 arm64_tahoe:   "9bcb8a1e1f0c776dff64f46ed87e9afc77bc1773ff9328cbeee63e7d0ad18c0e"
    sha256 cellar: :any,                 arm64_sequoia: "846a945967b2e189f3f3dc3e3b28855564e4f970edf704b0271140e0d123e60d"
    sha256 cellar: :any,                 arm64_sonoma:  "846a945967b2e189f3f3dc3e3b28855564e4f970edf704b0271140e0d123e60d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "fd063a2d1bf0a8ba3ce80e58446c88795c93046513fdf084b2f422f4216613f5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1b750d1cd632228479dfafc756a17d9890ad57f1db79150b82011082e58954bc"
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
