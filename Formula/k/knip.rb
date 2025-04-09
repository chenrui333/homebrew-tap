class Knip < Formula
  desc "Declutter your JavaScript & TypeScript projects"
  homepage "https://knip.dev/"
  url "https://registry.npmjs.org/knip/-/knip-5.48.0.tgz"
  sha256 "d2bc12117f4941feb160cfdd946b1bba48dea72b6955a3ba0002ce62f28b71c7"
  license "ISC"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "935bd581a6ca76ad4dacd8e7ebb440a05fb331bed30262cbe189feef858f3bcc"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "aaf51664553368022e8556c1d86b6a6414d624a753b10a12148c455cd7f75123"
    sha256 cellar: :any_skip_relocation, ventura:       "dc03e156c3305eb49dbb303de8eb7f6b103718952921a7b4771e3e7688659337"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "88ec5cd863e11b17f3fad70ed607bf55631a48fce413048716bfb9f4924c1c49"
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
