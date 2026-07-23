class Knip < Formula
  desc "Declutter your JavaScript & TypeScript projects"
  homepage "https://knip.dev/"
  url "https://registry.npmjs.org/knip/-/knip-6.29.0.tgz"
  sha256 "eccee286911747f88ae7942895a8c50b7426a3566fd3031445eda6a6ec6054e3"
  license "ISC"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any,                 arm64_tahoe:   "f57e749c3fb8c86e61bb031dc55ed21092c4b662dabbdb20307d497b19ccf372"
    sha256 cellar: :any,                 arm64_sequoia: "f57e749c3fb8c86e61bb031dc55ed21092c4b662dabbdb20307d497b19ccf372"
    sha256 cellar: :any,                 arm64_sonoma:  "f57e749c3fb8c86e61bb031dc55ed21092c4b662dabbdb20307d497b19ccf372"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d91869bb0a3330c545fbb3783f78d9d9f16ae0369d4b0cf36e9688c21db9e8f2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2c15b530e0a2413765768ca5aa3aebb605da29769be02bacbf72d07e9c22ada3"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
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
