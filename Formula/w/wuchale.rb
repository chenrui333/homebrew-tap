class Wuchale < Formula
  desc "Protobuf-like i18n from plain code"
  homepage "https://wuchale.dev/"
  url "https://registry.npmjs.org/wuchale/-/wuchale-0.16.4.tgz"
  sha256 "12bade24a3f6994a3e0b4805c732973485761ee80de3af423fb5b0bbcfdf1e89"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5839de3ca2c90b2c213b55c613c6c79a52781cbd12941fa19c73173d9406fc6e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "00c5aeb5b4c1a3b68c80fc13bd99a37dd127a51ad095e9b170281791a0775ac3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ad07c746b63bce0bfd8ced559d4155042d939deb847e9314e8e489de9faee755"
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
