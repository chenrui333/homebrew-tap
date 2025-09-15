class Wuchale < Formula
  desc "Protobuf-like i18n from plain code"
  homepage "https://wuchale.dev/"
  url "https://registry.npmjs.org/wuchale/-/wuchale-0.16.1.tgz"
  sha256 "e9338a59571b0cf4c9227cbc5e5106a9e057bb99a391f1d56b6f937cefde8ccf"
  license "MIT"

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
