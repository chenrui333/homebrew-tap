class Knip < Formula
  desc "Declutter your JavaScript & TypeScript projects"
  homepage "https://knip.dev/"
  url "https://registry.npmjs.org/knip/-/knip-6.10.0.tgz"
  sha256 "3601afa480260f940e333824808fe413ebdc5b728440fa5fdf8fd0ba92b9e3fc"
  license "ISC"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any,                 arm64_tahoe:   "5c2ab51b9b485df4ec057a5e3f9275c6f180b93595a123ec4274e9f95aeb4960"
    sha256 cellar: :any,                 arm64_sequoia: "54d24e8603dfbadf15d76a626f455edb108343ec719e06010a5a6855215670c4"
    sha256 cellar: :any,                 arm64_sonoma:  "54d24e8603dfbadf15d76a626f455edb108343ec719e06010a5a6855215670c4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b3e57279b4d8f3579bf4cc66869f6fd8209e8d4f00634592072ad647ccffd129"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c1428cb9fb195a8de41bb5c2cb43d3d0f5804490d9c8c207bda4672ed5370fd9"
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
