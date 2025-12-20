class Knip < Formula
  desc "Declutter your JavaScript & TypeScript projects"
  homepage "https://knip.dev/"
  url "https://registry.npmjs.org/knip/-/knip-5.76.1.tgz"
  sha256 "2fcce404efe49d278582dbc201afcd174e1414c3f54a2b39bc1f4db3f494c847"
  license "ISC"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any,                 arm64_tahoe:   "8ec29c5875abaffecca0d8d5e104a9446e350887156b05b8ecff55838f2b35a0"
    sha256 cellar: :any,                 arm64_sequoia: "d8098f99ef1766639fcf7c8b4bd25ac68bcd2c8c1d7cfae3f07ee61d2cba3842"
    sha256 cellar: :any,                 arm64_sonoma:  "d8098f99ef1766639fcf7c8b4bd25ac68bcd2c8c1d7cfae3f07ee61d2cba3842"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9066627c0b5f1fc67f30b2417df06479cab361880e6d17f3f268824a406091fd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7d609744d73454a1172823993e17cb1c196bffe09521cdef620ac4417dcbedcc"
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
