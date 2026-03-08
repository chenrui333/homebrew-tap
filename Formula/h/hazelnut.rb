class Hazelnut < Formula
  desc "Terminal-based automated file organizer"
  homepage "https://github.com/ricardodantas/hazelnut"
  url "https://github.com/ricardodantas/hazelnut/archive/refs/tags/v0.2.49.tar.gz"
  sha256 "b5a56cdd717dab2fe6ca0442377b4b8bc375639531a82bddeff8ec1ad31520eb"
  license "GPL-3.0-or-later"
  revision 1
  head "https://github.com/ricardodantas/hazelnut.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "bfe57b65d77b5518e0e0aa1f39f6cc39d7a205532879c1280cb338e75ce31983"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "45217d5d6f7c700414bd928e7e5e4978b3ca266138b0a2f7a276ab28f8383912"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b5da23818eff4dd006f1e09c0548bdde33d335cbf38695eddae96c31aecf1763"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c3606d2caae9ab4020cea826af580735f5298dbeecc98b766e0dc4209f3fc331"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e0275632e91375fa7852815f4fb153ec1309c3990c195cb38dfc63e882a5b129"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/hazelnut --version")

    downloads = testpath/"Downloads"
    downloads.mkpath

    config = testpath/"config.toml"
    config.write <<~TOML
      [[watch]]
      path = "#{downloads}"
      recursive = false

      [[rule]]
      name = "pdfs"

      [rule.condition]
      extension = "pdf"

      [rule.action]
      type = "move"
      destination = "#{testpath/"PDFs"}"
    TOML

    output = shell_output("#{bin}/hazelnut check --config #{config}")
    assert_match "Config is valid", output
    assert_match "1 watch paths", output
    assert_match "1 rules", output
    assert_match "pdfs", shell_output("#{bin}/hazelnut --config #{config} list")
  end
end
