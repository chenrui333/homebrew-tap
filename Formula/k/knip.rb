class Knip < Formula
  desc "Declutter your JavaScript & TypeScript projects"
  homepage "https://knip.dev/"
  url "https://registry.npmjs.org/knip/-/knip-6.6.1.tgz"
  sha256 "b534403ebeb1debce731111b7a7703f15ffed35d02a5970a7942c7cc8a12bfd1"
  license "ISC"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any,                 arm64_tahoe:   "b8faef95aac3e5aa5ff6aee09a501d36e5ae3cebfa8343559caff33e2e148875"
    sha256 cellar: :any,                 arm64_sequoia: "c58cf5e22388fc3f3638ebb61d3afbd0e32658cb62c3a0df83a3444de2e94e36"
    sha256 cellar: :any,                 arm64_sonoma:  "c58cf5e22388fc3f3638ebb61d3afbd0e32658cb62c3a0df83a3444de2e94e36"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "006ae4962ea6fd1ee814677bacf9d950bc39424afec4d4c64230210d52be10e1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e73227e6efa9b09948ef3fb223022ed07840f067cb73335dbfc23cfe33fb7383"
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
