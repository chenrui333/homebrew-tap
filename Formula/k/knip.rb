class Knip < Formula
  desc "Declutter your JavaScript & TypeScript projects"
  homepage "https://knip.dev/"
  url "https://registry.npmjs.org/knip/-/knip-5.73.3.tgz"
  sha256 "c704858ecd9d8f5161317a24bb4cf64f00bbe583fb64854681a89b872213b3f6"
  license "ISC"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any,                 arm64_tahoe:   "4d7d06c57ae17633b432ef6a22e888356758b45b55748559c1620cfa0cba7d14"
    sha256 cellar: :any,                 arm64_sequoia: "093adad5750aa4e5fdd6a3b7a4cba59a2126f79b880dbb4c836d1506fd14c948"
    sha256 cellar: :any,                 arm64_sonoma:  "093adad5750aa4e5fdd6a3b7a4cba59a2126f79b880dbb4c836d1506fd14c948"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d2ac4d94cea4fdd2c529b978e9ee85102486dd972532612e1f343fc8deeb5919"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8a2df788aacb28b6158a2bed08fac2fbe822a663dbe6af68dc1aa5b350981d15"
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
