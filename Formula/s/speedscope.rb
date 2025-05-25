class Speedscope < Formula
  desc "Fast, interactive web-based viewer for performance profiles"
  homepage "https://www.speedscope.app/"
  url "https://registry.npmjs.org/speedscope/-/speedscope-1.22.2.tgz"
  sha256 "094d7b66e53678a8340199cf0e98d768cd7020eb2ffc9860daf45286bfd97392"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e02a590b363c2dca1aa22cb07bd3d9e07f7c758f7a551396af7b6799fedd314c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c4099a33ee15ea2d37a419c87c398ebd8af55a860c530954c365a7da11a96bb8"
    sha256 cellar: :any_skip_relocation, ventura:       "524eacdb13c04a8ae9731673b11b99eca60127d6f9341748581a67dc27ba11dc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d72bd16c1b6428a7786df210a9bd796134601eb97c92e29ee528c326f2a7cfe6"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/speedscope --version")

    resource "test_profile" do
      url "https://raw.githubusercontent.com/jlfwong/speedscope/refs/heads/main/sample/profiles/Chrome/116/Trace-20230603T221323.json"
      sha256 "9d5757048341ee60b57d3c8ea5856c758ae7a10de10f3d8189eabbb58bc40205"
    end

    testpath.install resource("test_profile")
    system bin/"speedscope", testpath/"Trace-20230603T221323.json"
  end
end
