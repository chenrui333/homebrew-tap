class Wuchale < Formula
  desc "Protobuf-like i18n from plain code"
  homepage "https://wuchale.dev/"
  url "https://registry.npmjs.org/wuchale/-/wuchale-0.17.2.tgz"
  sha256 "c1adb476cac7aa8672dae9094ce096f8d20218e521a49e4af862b292a040ead7"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a59408c964e28ca1089a2751b7186d3a782e0a61810b768870a2526f8b6f14cc"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8b680405d58795075672f7cfb14a9684917f2d0049ae57183588cdc7629309da"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "64b1755c0562f2bab0735e0ad63b8aaa009e4e55c714b3c04b42df4e3ff6c158"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8bf44134f4ad7985b684a52e45c031ab577a416e84799089a45f9dec516cf33a"
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
