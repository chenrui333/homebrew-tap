class Knip < Formula
  desc "Declutter your JavaScript & TypeScript projects"
  homepage "https://knip.dev/"
  url "https://registry.npmjs.org/knip/-/knip-5.82.1.tgz"
  sha256 "034b0e799e74e1c5059a25f15d14613031a250a29a46ea21e99a5eeee5439f39"
  license "ISC"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any,                 arm64_tahoe:   "036da3f94dba63b0c666f85829ee5d02fa0509cfebf3adfc9c3dbe6406ce6228"
    sha256 cellar: :any,                 arm64_sequoia: "17a30fa9d4f029ee57cdebf1a9a2ef1430bb3922f5868c65f78d746085fd212e"
    sha256 cellar: :any,                 arm64_sonoma:  "17a30fa9d4f029ee57cdebf1a9a2ef1430bb3922f5868c65f78d746085fd212e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7209e7639a150f456529d1c6759a12cf028b0e2fd5eea428b9d6f21666be788d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fce5e83ecc3a6682ecfcbbef5ab28cc2f8120a0a53acfb2b21a1605f444200fc"
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
