class Wuchale < Formula
  desc "Protobuf-like i18n from plain code"
  homepage "https://wuchale.dev/"
  url "https://registry.npmjs.org/wuchale/-/wuchale-0.16.5.tgz"
  sha256 "28948b4ba4f35b63123ea79ad74ce48222dd509fdad5e4a1ea727999693b5017"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8841262e86baaa6bc5e590ec7d17b0e3b1d77aad1f6fb788179f23971a3d9000"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "dbdd913a511e9150e700f29599a81563316fab3939bb9f88aaf480eb5a5c5ea7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fdf08ba15d8bcf9e597bd35fde2bb56d4bb6859a2edbf46a7463919a2bc06b07"
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
