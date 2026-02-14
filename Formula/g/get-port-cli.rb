class GetPortCli < Formula
  desc "Get an available port"
  homepage "https://github.com/sindresorhus/get-port-cli"
  url "https://registry.npmjs.org/get-port-cli/-/get-port-cli-3.0.0.tgz"
  sha256 "42bda9c04261747640267510fdaaeffc6cd712a3c54d675e43dc932cc0a0222f"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6190a1ea582e56aab0a819d18d819985cfc5eec95b6b63f3d1fa1568bc1f29cc"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "56d5d03308b8c19f6dd7ff779e586b90f659dbacd5e2c4b09f1508c066069c09"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "60d8a1abfcb91ebe61d41372fd7d85345d42c5d7dd34ec47770e02cfa3ca94b2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0e61f926d735d4d0d81c1e2e224d38d45af877fa196f208c2a4849518019757b"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/get-port --version")

    system bin/"get-port", "--host=127.0.0.1"
  end
end
