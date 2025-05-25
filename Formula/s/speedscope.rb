class Speedscope < Formula
  desc "Fast, interactive web-based viewer for performance profiles"
  homepage "https://www.speedscope.app/"
  url "https://registry.npmjs.org/speedscope/-/speedscope-1.22.2.tgz"
  sha256 "094d7b66e53678a8340199cf0e98d768cd7020eb2ffc9860daf45286bfd97392"
  license "MIT"

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
