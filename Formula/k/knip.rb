class Knip < Formula
  desc "Declutter your JavaScript & TypeScript projects"
  homepage "https://knip.dev/"
  url "https://registry.npmjs.org/knip/-/knip-5.50.5.tgz"
  sha256 "6895d459cce4bbf704a15a5c6eeb2d6f477c10babf443d95228235bc70bf41a2"
  license "ISC"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d16613a7d21fcde258d329ebcd24eee30ebabab9ebe5947e5ec262207c1a67b9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8553573b870947d1e938403dd3b7df00d4a9438003bb5693205dea319560eee8"
    sha256 cellar: :any_skip_relocation, ventura:       "b37a7033af9aad073b200debbb7df93f62171717095de3a0eaac0aa02e092ebb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "aa18428a2d8e51d7e1cc2c62cafb1469617f95b11269607f176f8151cc352d33"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/knip --version")

    (testpath/"package.json").write <<~JSON
      {
        "name": "my-project",
        "scripts": {
          "knip": "knip"
        }
      }
    JSON

    system bin/"knip", "--production"
  end
end
