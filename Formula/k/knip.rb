class Knip < Formula
  desc "Declutter your JavaScript & TypeScript projects"
  homepage "https://knip.dev/"
  url "https://registry.npmjs.org/knip/-/knip-5.57.2.tgz"
  sha256 "9ccabe43ad7083352b9054364bac875072a72a2da3e4a504d65ed822e080a217"
  license "ISC"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any,                 arm64_sequoia: "9c4e1e6bb753d5a3da92f0ea408c605dfb1ce7ce612c0df01054b4028230dd58"
    sha256 cellar: :any,                 arm64_sonoma:  "52cea74f8fb7eda98a042d353b05d2a00ba1488de8c9b97bb2bbdfe74ccf8f7d"
    sha256 cellar: :any,                 ventura:       "2a7691898d3da4f66d81ebf2b0b679b99b4a58746aa1791c00fdd4a11a4665dc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cf48db83d877ee12c40b79167f7394ca16fdd9e9115d1abcaf901c4ea0ca336c"
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
