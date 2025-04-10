class Knip < Formula
  desc "Declutter your JavaScript & TypeScript projects"
  homepage "https://knip.dev/"
  url "https://registry.npmjs.org/knip/-/knip-5.50.2.tgz"
  sha256 "739b00456446a7b1cd2b9c930175f1cb860ba8c228db3b95ccb388b76eacb649"
  license "ISC"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5de9ec64eb1136c5f5ec26fdb7894afeaa6fa49da5038dc39571a35855ba4092"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e68191edea5ec4983b78adb801207783623047fa3666a1b0d6f13dcc9b7f0d55"
    sha256 cellar: :any_skip_relocation, ventura:       "c2f1fffb7d2692ac481045f17d6e88bd0d040732fcea058d5153c4565ef37c7a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7208e06350a431b09f5193f84668e6e7644c1d731750d4481eafab5a0b06d18b"
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
