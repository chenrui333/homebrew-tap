class Knip < Formula
  desc "Declutter your JavaScript & TypeScript projects"
  homepage "https://knip.dev/"
  url "https://registry.npmjs.org/knip/-/knip-6.16.0.tgz"
  sha256 "fa69194f4f73ca94739de3f65bf8f2baad383fe34806918674a2cd3eb2507fca"
  license "ISC"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any,                 arm64_tahoe:   "a2ed9ee70ea1560106fd9d452ec7c7824733e9fb1af10b74fab066e4e6fac164"
    sha256 cellar: :any,                 arm64_sequoia: "90af5965a012c8e820d977e75d296fe5cc91f06783f92a6052f88d7725e704b2"
    sha256 cellar: :any,                 arm64_sonoma:  "90af5965a012c8e820d977e75d296fe5cc91f06783f92a6052f88d7725e704b2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "80d51b640b014d6f1ee8401045cac652589dc0b8007cbd50cb8ed9ca6c41f30a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d8e144d0f219ddda4b5146f44964e16e057b49572465c5d2f76b94b9357f3a83"
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
