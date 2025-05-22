class Knip < Formula
  desc "Declutter your JavaScript & TypeScript projects"
  homepage "https://knip.dev/"
  url "https://registry.npmjs.org/knip/-/knip-5.57.2.tgz"
  sha256 "9ccabe43ad7083352b9054364bac875072a72a2da3e4a504d65ed822e080a217"
  license "ISC"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any,                 arm64_sequoia: "b5a8e9493e4b915a3819c6a524fb8a5bb73f0ca4db16dc971e4592a0bd7335ac"
    sha256 cellar: :any,                 arm64_sonoma:  "2708684299359d966a17ce23f45e184bdb9a6b10f84f603b75b7c115e4cdd028"
    sha256 cellar: :any,                 ventura:       "1323965b322e9f754373b3e1d7c74a197b7db7d99dd1fc3ccff0271f01a9365f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "77870564cec769d33093041cbb98e20cf0c3e2380c93d7ed93e2ee97842ffe91"
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
