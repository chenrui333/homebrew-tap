class Knip < Formula
  desc "Declutter your JavaScript & TypeScript projects"
  homepage "https://knip.dev/"
  url "https://registry.npmjs.org/knip/-/knip-6.11.0.tgz"
  sha256 "c0802e61f9f54386962e317ed4db2a912e65a69ea818f744c322abe25eb56ae5"
  license "ISC"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any,                 arm64_tahoe:   "2724548ba3211e64bb19ea26aa63642a400e9ddc6679ff1b30e55711c5a25e7f"
    sha256 cellar: :any,                 arm64_sequoia: "5d3cad450a678e88e9eec8de0648be34c8f48faa275f79f5a5159a8513bd46f2"
    sha256 cellar: :any,                 arm64_sonoma:  "5d3cad450a678e88e9eec8de0648be34c8f48faa275f79f5a5159a8513bd46f2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3971b82f1677c5d115d66a913e2f4b59304bef59560dc265229fb561e1799561"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8fcacd2d42ca1fc4975f15fc3c768aa6261c599785306fa850b48ca8969b0833"
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
