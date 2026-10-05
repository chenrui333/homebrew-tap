class Humanlayer < Formula
  desc "Command-line interface for HumanLayer"
  homepage "https://www.humanlayer.dev/"
  url "https://registry.npmjs.org/humanlayer/-/humanlayer-0.17.2-npm.tgz"
  version "0.17.2-npm"
  sha256 "3457fbfe110135a6cc783f49e16344c0591916c816d2d871f2a130006c954112"
  license "Apache-2.0"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4a00493522120f932178361907db811ce3151fbe8e189c938cbc635eeaa8afdf"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4a00493522120f932178361907db811ce3151fbe8e189c938cbc635eeaa8afdf"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1a5ec1ad0105d13485129b6351085ef444970eecd0d281f643fb12e7beab07ce"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1a5ec1ad0105d13485129b6351085ef444970eecd0d281f643fb12e7beab07ce"
  end

  depends_on "node"

  deny_network_access!

  def fetch
    system "npm", "install", *std_npm_args(prefix: buildpath/"npm-fetch")
  end

  def install
    system "npm", "install", "--offline", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    ENV["HUMANLAYER_API_KEY"] = "test_token"

    assert_match version.to_s, shell_output("#{bin}/hlyr --version")

    output = shell_output("#{bin}/hlyr thoughts status 2>&1", 1)
    assert_match "Run \"humanlayer thoughts init\" first", output
  end
end
