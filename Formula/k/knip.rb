class Knip < Formula
  desc "Declutter your JavaScript & TypeScript projects"
  homepage "https://knip.dev/"
  url "https://registry.npmjs.org/knip/-/knip-6.41.0.tgz"
  sha256 "17fb66978f94396a16e4e7247fbdce08b61991a8d628309f91e8a1abe0186b83"
  license "ISC"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any,                 arm64_tahoe:   "bdd1d85eb0905fa1913e775e4bccb46f400df87924d1af9805274879f4ce2ab7"
    sha256 cellar: :any,                 arm64_sequoia: "bdd1d85eb0905fa1913e775e4bccb46f400df87924d1af9805274879f4ce2ab7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7f833b489af01dd98addbfde750856330e3849d2bdd0dd7ec0f6d168d053ba6b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c46b9d86e0553f000cb59c2a0558c37eaa31d7df4f097daefb2e1f176a720b38"
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
