class Knip < Formula
  desc "Declutter your JavaScript & TypeScript projects"
  homepage "https://knip.dev/"
  url "https://registry.npmjs.org/knip/-/knip-5.74.0.tgz"
  sha256 "a5279e103faf8cd9e830404deee4c5a023207d015dc0998d82228257202f8b69"
  license "ISC"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any,                 arm64_tahoe:   "b6646e413bf24edd3c7c4b9fa9b64a6d6daa1dcbda1ce859dfffca48db214ceb"
    sha256 cellar: :any,                 arm64_sequoia: "b10ccd83c5d1b6240094b1b56d1d3a42820060371cea576db0fc423bc34f2a0c"
    sha256 cellar: :any,                 arm64_sonoma:  "b10ccd83c5d1b6240094b1b56d1d3a42820060371cea576db0fc423bc34f2a0c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2dd80c8c48dcde814905d13f533d3d9bcc5611f3cc4ebcd95af9b4905bcbbc20"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f316067f638c702f891172b849f1ece329a752b03d5039e24e5f6afc28397560"
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
