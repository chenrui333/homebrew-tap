class Knip < Formula
  desc "Declutter your JavaScript & TypeScript projects"
  homepage "https://knip.dev/"
  url "https://registry.npmjs.org/knip/-/knip-5.71.0.tgz"
  sha256 "bf20448e09973719365dd71148345ed2fe3cbda504eccd15aeabb5a2b9d9c5ca"
  license "ISC"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any,                 arm64_tahoe:   "67bfc3f0b51a73fe85024a9bd0338e38db2ba1adb8212c195785a330ad674489"
    sha256 cellar: :any,                 arm64_sequoia: "bbcb6bdd218d82d3d726c03730edf8e38ca99bfd81a5f3c441f3f4966087e8c7"
    sha256 cellar: :any,                 arm64_sonoma:  "bbcb6bdd218d82d3d726c03730edf8e38ca99bfd81a5f3c441f3f4966087e8c7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "fbaa370c45a15ddb069d1e3d8cd04b7bc221c3499c59ec8ea66ff512f4035c62"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "89e9e4997bd407d16da94f2894024bb0250c581049382b23f29d4d903b5516e4"
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
