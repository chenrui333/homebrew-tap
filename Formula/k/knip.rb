class Knip < Formula
  desc "Declutter your JavaScript & TypeScript projects"
  homepage "https://knip.dev/"
  url "https://registry.npmjs.org/knip/-/knip-5.50.2.tgz"
  sha256 "739b00456446a7b1cd2b9c930175f1cb860ba8c228db3b95ccb388b76eacb649"
  license "ISC"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "67d60b3854260990fa867cec3d8c74a2bedaabfce816f2c228c9755bc7e90fdd"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "36b05c7e4fa84777510c8f8a971ca57ca1cd8ee81b26dd5ccbae8ff3bf2eb769"
    sha256 cellar: :any_skip_relocation, ventura:       "36e3b7d48143d1aa1b77963b2d1a81e98cdfd295bc624ed6be5a00c4dcc2dc89"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0daaea3584d36096fff2717855d9424a0b6498ffe2c2aaabbcfc3a9d6e5a6c89"
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
