class Knip < Formula
  desc "Declutter your JavaScript & TypeScript projects"
  homepage "https://knip.dev/"
  url "https://registry.npmjs.org/knip/-/knip-5.77.1.tgz"
  sha256 "ac016b27abe1e2297736e3af1a706fe394a42d33f1b065beee1b85e66a5cc097"
  license "ISC"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any,                 arm64_tahoe:   "a706852bd5f3138c1b16ada4f2014af724e3a5c01cd55c0c2631bdcb611d6c6c"
    sha256 cellar: :any,                 arm64_sequoia: "5ae8782c3b3344001a2f977ff7dbe4835b92caff75449ea0a03ba1eab11e05aa"
    sha256 cellar: :any,                 arm64_sonoma:  "5ae8782c3b3344001a2f977ff7dbe4835b92caff75449ea0a03ba1eab11e05aa"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "938a5b26f17e41b5e08ac75ae7ac1e0257e224377162c74c5bbf49dd3347a7c8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "204be59121b86298ab23031b68cb0c2af6bfbe3d400dbd69af1b37a8221ba05c"
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
