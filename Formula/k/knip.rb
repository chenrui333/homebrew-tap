class Knip < Formula
  desc "Declutter your JavaScript & TypeScript projects"
  homepage "https://knip.dev/"
  url "https://registry.npmjs.org/knip/-/knip-6.6.3.tgz"
  sha256 "e744c00bdce021cbd82f34563951d18f1bb48fcac816eb1c9741d492ccaa3709"
  license "ISC"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any,                 arm64_tahoe:   "a740745065baa810f471f9d891cf7f1d9c7902b495cff83f87075adf2dafd87a"
    sha256 cellar: :any,                 arm64_sequoia: "5d8b09d132254d793e849450635b4c7df4e71c2f2baf4129f5010ee829d40162"
    sha256 cellar: :any,                 arm64_sonoma:  "5d8b09d132254d793e849450635b4c7df4e71c2f2baf4129f5010ee829d40162"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "01ce79d1107fc13a0f586c23294987df7df2a8a881f6dbc71f575c5ec41df032"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "56c1ad47f710d6fdd7dbefc57f2fe7e7858875c655a2de6ec7d50c42bf5d1e0c"
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
