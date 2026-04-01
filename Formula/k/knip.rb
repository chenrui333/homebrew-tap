class Knip < Formula
  desc "Declutter your JavaScript & TypeScript projects"
  homepage "https://knip.dev/"
  url "https://registry.npmjs.org/knip/-/knip-6.1.1.tgz"
  sha256 "f017a3eecc79286c2715f3c78f38a7d5cf1b712c0601048f83e61bc98ce2db07"
  license "ISC"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any,                 arm64_tahoe:   "cd94d54114c346b7c3d8d1b6deae9eafe466c2c5c619faf9c9f032b568f25ef7"
    sha256 cellar: :any,                 arm64_sequoia: "73e14c2280d5971b1218f96baeddc08843a4341ff6593e0743fef7d1802721d7"
    sha256 cellar: :any,                 arm64_sonoma:  "73e14c2280d5971b1218f96baeddc08843a4341ff6593e0743fef7d1802721d7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4880eb3009d385195078d6d072ee75781f9c7a62a71e46e1d334c76eafff9487"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "09944467a637ae63f15c336309d3b9d0a58cc14fd2f74a914f75f11d28c5ab88"
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
