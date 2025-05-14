class Knip < Formula
  desc "Declutter your JavaScript & TypeScript projects"
  homepage "https://knip.dev/"
  url "https://registry.npmjs.org/knip/-/knip-5.56.0.tgz"
  sha256 "eeb81baa5ec8f550a29b09c6c0c1cfbb7af6431ef8d8986ca4177fc8b8b9c6bb"
  license "ISC"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any,                 arm64_sequoia: "dd435d2ea91bb619640a60c66693db78fe64226be29c46caa4759fd916fc3acd"
    sha256 cellar: :any,                 arm64_sonoma:  "fe98a30a821378f737bc2d6268b10d62d89d1b7082a94b1133666afa7d664fd1"
    sha256 cellar: :any,                 ventura:       "029cd2787e16dbe8add23d4012b61e44760c6c42dd1ab876d79b95d0e32fcdb2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0303949967c79ac53deddf1ce28bda397c327805d309f5c97978b8c93cdfbde7"
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
