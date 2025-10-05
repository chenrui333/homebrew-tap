class Wuchale < Formula
  desc "Protobuf-like i18n from plain code"
  homepage "https://wuchale.dev/"
  url "https://registry.npmjs.org/wuchale/-/wuchale-0.17.2.tgz"
  sha256 "c1adb476cac7aa8672dae9094ce096f8d20218e521a49e4af862b292a040ead7"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "59224f9aeaa9d1a02d7d678af7109fc3a1c8b5fb2c8caa583308b3a476cc7ed6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e54399c3c562d5fd2beff5d05482b574a857f17ac4bfa73ff3354669f31fa89a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "cda02f45eeae01891510884d127e80291030435e02cf4570b40f46b9df2df74a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c6b5862ff933fea4013646bdc79fa7002e55780065145fdc0fe8f4888a90dcd2"
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
