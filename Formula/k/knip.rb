class Knip < Formula
  desc "Declutter your JavaScript & TypeScript projects"
  homepage "https://knip.dev/"
  url "https://registry.npmjs.org/knip/-/knip-6.22.0.tgz"
  sha256 "59d3d39c5dff64eb2c5c5147556c93401980034fec18cfe35eee64d73e8e95b6"
  license "ISC"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any,                 arm64_tahoe:   "cbbe37bb5c59f3c443739bee7e665bfeab96bba25006c7b4547d44655d2944be"
    sha256 cellar: :any,                 arm64_sequoia: "b77ea866c7c7c987e377890f236c065a4848aafacb85bd49ef73c13f1b789990"
    sha256 cellar: :any,                 arm64_sonoma:  "b77ea866c7c7c987e377890f236c065a4848aafacb85bd49ef73c13f1b789990"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "bc713966a7343570cf8beebb8f85d0d3c497f453bb66522e2ddbb1b3de215fe7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c9b35221b2891f326a6b6e8c7fb0650f0d0460d4fece18ff0df6375ddf3e9958"
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
