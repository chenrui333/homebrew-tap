class Speedscope < Formula
  desc "Fast, interactive web-based viewer for performance profiles"
  homepage "https://www.speedscope.app/"
  url "https://registry.npmjs.org/speedscope/-/speedscope-1.23.1.tgz"
  sha256 "399319ce48f37746e4b48cdefa81e0dc41744ab2079204727c6aececf3cbe633"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2d60ecbc1f7afb0330908f06ab021413ddd96b9108174075a759aefa390aca63"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "131f832186f6d526954bba457215c547e0e90fe9630cd9c07c056bb4e8b7f16f"
    sha256 cellar: :any_skip_relocation, ventura:       "0dad33090fef9f527ea7fbe62b7ca9087592b21c87d982db209a1a44a5d49e49"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "dc748c538e3e56842746aaba9e2cba85835580b0365cacb32d4d5a8a549de3e3"
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
