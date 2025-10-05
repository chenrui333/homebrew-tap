class Wuchale < Formula
  desc "Protobuf-like i18n from plain code"
  homepage "https://wuchale.dev/"
  url "https://registry.npmjs.org/wuchale/-/wuchale-0.17.0.tgz"
  sha256 "553da886b943d6b90d545ccd828ebdf98c1380665ed19c205b91276b3b24a6f1"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e73fc2ad3eceaae5b77a867bdd74aa4d64f5ddf20b6d7fddbd26d266b000db1c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1e21c4400fa2736e0eadfaa9831a9a2e775d60f808f847b4629554cfa4ae4647"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6d7ea9b63fd716f33e46f3ee71964bbf14a9e98606b1cd7bef94a52356aa1d8a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c0bb5d45507b2ce8af18287740e93733629f0db4a72b701dfa3fdf8b1fb98070"
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
