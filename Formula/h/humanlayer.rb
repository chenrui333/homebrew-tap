class Humanlayer < Formula
  desc "Command-line interface for HumanLayer"
  homepage "https://www.humanlayer.dev/"
  url "https://registry.npmjs.org/humanlayer/-/humanlayer-0.17.2-npm.tgz"
  version "0.17.2-npm"
  sha256 "3457fbfe110135a6cc783f49e16344c0591916c816d2d871f2a130006c954112"
  license "Apache-2.0"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "fbb993e97b47c5f178a9a9322896ab5de7172075d6fb83520a492b2dbd9b07f2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fbb993e97b47c5f178a9a9322896ab5de7172075d6fb83520a492b2dbd9b07f2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fbb993e97b47c5f178a9a9322896ab5de7172075d6fb83520a492b2dbd9b07f2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4ef6ba62fc1d6a9f287012be4cc77d70b861c276e7f8b123104b906ea4b279ea"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4ef6ba62fc1d6a9f287012be4cc77d70b861c276e7f8b123104b906ea4b279ea"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    ENV["HUMANLAYER_API_KEY"] = "test_token"

    assert_match version.to_s, shell_output("#{bin}/hlyr --version")

    output = shell_output("#{bin}/hlyr thoughts status 2>&1", 1)
    assert_match "Run \"humanlayer thoughts init\" first", output
  end
end
