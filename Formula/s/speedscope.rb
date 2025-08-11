class Speedscope < Formula
  desc "Fast, interactive web-based viewer for performance profiles"
  homepage "https://www.speedscope.app/"
  url "https://registry.npmjs.org/speedscope/-/speedscope-1.23.1.tgz"
  sha256 "399319ce48f37746e4b48cdefa81e0dc41744ab2079204727c6aececf3cbe633"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c0e1476d9546951ed71625fcab03c48d0b18fcd1828c8505c368109a31bf067e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8f759e5b737fb57762762e8d5d36d2df7ea900611a94741d342fee7092c1c0a3"
    sha256 cellar: :any_skip_relocation, ventura:       "12e1bf912ac9f33b9b3cf358bab52838a8b6cb2e4a017e299b28bc86de05858a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ac3728282bc1bcf623b500251ddb04ed24639ea61e9bf54591239bb0df28c1b3"
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
