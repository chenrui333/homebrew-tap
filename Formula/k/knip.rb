class Knip < Formula
  desc "Declutter your JavaScript & TypeScript projects"
  homepage "https://knip.dev/"
  url "https://registry.npmjs.org/knip/-/knip-6.0.3.tgz"
  sha256 "cd89b86b8498450486f178d6f833e4a4fc62962c1d36743e3edbfdd2f5e022c0"
  license "ISC"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any,                 arm64_tahoe:   "a1851a33da1207133752e5f0718381b7dd25212366cb26cf67ae310b5a90e809"
    sha256 cellar: :any,                 arm64_sequoia: "7a16eb9ddaa7c070776f040210ae11f567c05d9819586807510dbf8af5677a38"
    sha256 cellar: :any,                 arm64_sonoma:  "7a16eb9ddaa7c070776f040210ae11f567c05d9819586807510dbf8af5677a38"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "cfb70187618dae1fd68262c3623dd1adad031530cc0d0cf056b5f7d9e68b3e0b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "75f5b77c17f2e3143f9546d22ae2bd7e1be0acf1888b7eaaaaa5bf1dde99b933"
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
