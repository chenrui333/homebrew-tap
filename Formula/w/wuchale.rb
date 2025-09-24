class Wuchale < Formula
  desc "Protobuf-like i18n from plain code"
  homepage "https://wuchale.dev/"
  url "https://registry.npmjs.org/wuchale/-/wuchale-0.16.5.tgz"
  sha256 "28948b4ba4f35b63123ea79ad74ce48222dd509fdad5e4a1ea727999693b5017"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9e900717b1abb3b8c2f73ba0d0b444db0341f9561452291a559b9b3a7d474934"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1efb66b4b78190c1590d6c71ee8fe873ce410e76ff770fe678bdb6de2d82abca"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3a9d84e9bb2316c55ad41610d330e34c0105b376fa45701d45e6cc41330eeaef"
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
