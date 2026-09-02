class Knip < Formula
  desc "Declutter your JavaScript & TypeScript projects"
  homepage "https://knip.dev/"
  url "https://registry.npmjs.org/knip/-/knip-6.34.0.tgz"
  sha256 "c68ab497aaeee9fb5f6a21d7d9f276ac1a3a0c2908bf19e80a576b5ff2c8d910"
  license "ISC"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any,                 arm64_tahoe:   "fda66fa25907ce479931cdff62677ac7eeaff088ea90aa207e20a2c87c706d0e"
    sha256 cellar: :any,                 arm64_sequoia: "fda66fa25907ce479931cdff62677ac7eeaff088ea90aa207e20a2c87c706d0e"
    sha256 cellar: :any,                 arm64_sonoma:  "fda66fa25907ce479931cdff62677ac7eeaff088ea90aa207e20a2c87c706d0e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "105709fa8a0111a902020830c5cd14820c1d1ebd95f022fb3ccfb07d8688be43"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c3c5a4e33a4638f7b305d0af0e0ac299974abcf398dd61bbdac36ea277360c78"
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
