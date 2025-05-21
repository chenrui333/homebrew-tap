class Knip < Formula
  desc "Declutter your JavaScript & TypeScript projects"
  homepage "https://knip.dev/"
  url "https://registry.npmjs.org/knip/-/knip-5.57.1.tgz"
  sha256 "f6fa81a1ef3649bb6989fe40d3f9efef8ac15f47c8da1ab33dffc6b317b10879"
  license "ISC"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any,                 arm64_sequoia: "01494a3146bbf2f9dbeb2d16744eae5efc0fc97a720e0e5de370c25c605ee991"
    sha256 cellar: :any,                 arm64_sonoma:  "13710085d23a92bb650261815d27577020f268d864ebcfc25871ced27e262252"
    sha256 cellar: :any,                 ventura:       "f5d5241146731a00d678677d4483cd915318a125ba5087770ad36b5677f24a16"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2d83b0983b0b784134a012f581a64ef1e2f43e27134768e844bb3a0ea560e767"
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
