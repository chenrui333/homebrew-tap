class Dxt < Formula
  desc "MCP server for Shadcn UI v4"
  homepage "https://github.com/anthropics/dxt"
  url "https://registry.npmjs.org/@anthropic-ai/dxt/-/dxt-0.2.6.tgz"
  sha256 "d98427c2178d80d4da6f27a8255c2dbb40da9c59c7c232181435a7e253f3c40e"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "00deebbf8f49df58607e66ceb84115dbe4cd2fa62d0c73c7b52c32705736169b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "13bd00a70a1a1cecddd5782038c3586c99442160d5b83cf400017715ad7ca3c8"
    sha256 cellar: :any_skip_relocation, ventura:       "01775244906d3b038d80dd32357c77a30c920a0e46bd573fa9014aa85db374dc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "52a770bacdee13c93b89bd853c1118351208e2e48d575a00fc73aa5faa87bb72"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/dxt --version")

    output = shell_output("#{bin}/dxt init --yes .")
    assert_match "Creating manifest.json with default values...", output
    assert_equal "A DXT extension", JSON.parse((testpath/"manifest.json").read)["description"]
  end
end
