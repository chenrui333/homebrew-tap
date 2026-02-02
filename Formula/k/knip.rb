class Knip < Formula
  desc "Declutter your JavaScript & TypeScript projects"
  homepage "https://knip.dev/"
  url "https://registry.npmjs.org/knip/-/knip-5.83.0.tgz"
  sha256 "044c437b69df8e749f4ed0b03515376f72cfa017e73a560f83e7f271f589eaa2"
  license "ISC"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any,                 arm64_tahoe:   "ecf533c5a089b588bb5bc95514ca5437c0afd5e338bfef52dd8fc78cc535e003"
    sha256 cellar: :any,                 arm64_sequoia: "5b82a2a2e5bbbafa555fb1ca0f4ae9c78fc90158d61002b07ee499564ef1c416"
    sha256 cellar: :any,                 arm64_sonoma:  "5b82a2a2e5bbbafa555fb1ca0f4ae9c78fc90158d61002b07ee499564ef1c416"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0efef92aaad7f0cf4e2ade8b19d38185974275252ba24f5748b146533bdf9cce"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f31b0eea1714cb75fa4610e9758fe8d61ecf5f0e82fe73944e7814745201939a"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    (testpath/"package.json").write <<~JSON
      {
        "name": "my-project",
        "scripts": {
          "knip": "knip"
        }
      }
    JSON

    assert_match version.to_s, shell_output("#{bin}/knip --version")

    system bin/"knip", "--production"
  end
end
