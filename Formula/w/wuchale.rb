class Wuchale < Formula
  desc "Protobuf-like i18n from plain code"
  homepage "https://wuchale.dev/"
  url "https://registry.npmjs.org/wuchale/-/wuchale-0.16.3.tgz"
  sha256 "d8e5efb72fc09478a7ceb9295ec0496b5a4144555b22e110e43ef7fbeeba90b2"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "829ae9f03fb8d7c97bedaf498a64dcf7e7fed813190500e4c9fbb06e2fce2947"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a7b4a5dfb612c29c3fddacb9122a067d781713e5de44b99ba2c8123b5232f24d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "938a4e35817eb3a38298a7ff6179678d68d2e005b9f57f8234e1c977b37669e0"
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
