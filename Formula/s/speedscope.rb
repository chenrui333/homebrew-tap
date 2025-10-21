class Speedscope < Formula
  desc "Fast, interactive web-based viewer for performance profiles"
  homepage "https://www.speedscope.app/"
  url "https://registry.npmjs.org/speedscope/-/speedscope-1.24.0.tgz"
  sha256 "e2c2a17af16072033291670652cea3cf6cefc59ce0078bd5741f556f7cf4c9ff"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, all: "0a2ee767a1d79f8c2672a49cc7527da90ec233eb611393a5131aa8c59d654786"
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
