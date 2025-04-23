class NestCli < Formula
  desc "CLI tool for Nest applications"
  homepage "https://nestjs.com/"
  url "https://registry.npmjs.org/@nestjs/cli/-/cli-11.0.7.tgz"
  sha256 "00ec0d45d8477530ef5b2d3cf7c7d5d643feceab490e1657a5fec41f1a8ab9ab"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ec9b60bd462058c143546cc2b4c8d5107f611f1ab36066bb2cbda5b3a863b7fe"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "328a9c0eed8af32446d3afd8e1b0ee3cbd2b65f5f376e0541bbc93346dbee623"
    sha256 cellar: :any_skip_relocation, ventura:       "571ba1117487feba079957d3a3d3d4b35d2b6f4e51c264449757d7e86b237963"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "847279d91b5278957b4a619942926a2597e655a9eb6853de368069caa49ff370"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/nest --version")

    output = shell_output("#{bin}/nest info")
    assert_match "System Information", output
  end
end
