class Knip < Formula
  desc "Declutter your JavaScript & TypeScript projects"
  homepage "https://knip.dev/"
  url "https://registry.npmjs.org/knip/-/knip-5.66.2.tgz"
  sha256 "9bad92ec09a35a5753de3474a1381d87522e2c1aeaad3508c179e766e8327501"
  license "ISC"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any,                 arm64_tahoe:   "4bc65743b4c9df09dc852f3a84affaa0b28e236ecf7587047fa52afb070ab0cd"
    sha256 cellar: :any,                 arm64_sequoia: "89de585a54c09d4ad3bd5e25211a2899bbb4c06b544aebf66412f0b39bd50193"
    sha256 cellar: :any,                 arm64_sonoma:  "89de585a54c09d4ad3bd5e25211a2899bbb4c06b544aebf66412f0b39bd50193"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0a6b34c9d8bd00044b7fd284728880cd48cf0bc446e2d8d648dbf6a464b05aaf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fd68db7f70bedc3141ed7444f81e6ff2224c8141d0cd0a7c0aa89e8b0474de66"
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
