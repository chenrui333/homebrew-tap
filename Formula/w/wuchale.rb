class Wuchale < Formula
  desc "Protobuf-like i18n from plain code"
  homepage "https://wuchale.dev/"
  url "https://registry.npmjs.org/wuchale/-/wuchale-0.16.2.tgz"
  sha256 "c4df5ab49dc483f4c67191b805f768ce5d4dfa532b650f2ea6b0376b9943a867"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "85cd272f060154bea802ce124b4a28f0642215f7f0b66df88afde5ac425ef967"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "395123989e881eab6189da84b3885c62499a8587feb1d1b19136b560e6d7d2dc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d185c8d40913379868bc36cf0f4b7ce0e4154bd43f0a25310dbf647dab4d6a23"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    (testpath/"wuchale.config.mjs").write <<~EOS
      export default {};
    EOS

    system bin/"wuchale", "--config", testpath/"wuchale.config.mjs", "init"
    assert_path_exists testpath/"wuchale.config.mjs"

    output = shell_output("#{bin}/wuchale --config #{testpath}/wuchale.config.mjs status")
    assert_match "Locales: \e[36men (English)\e[0m", output
  end
end
