class Knip < Formula
  desc "Declutter your JavaScript & TypeScript projects"
  homepage "https://knip.dev/"
  url "https://registry.npmjs.org/knip/-/knip-5.84.1.tgz"
  sha256 "6573e7e851023cbe93d57d0967ed386a244bf18d65471d097dbc47df30125777"
  license "ISC"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any,                 arm64_tahoe:   "715a7578597a863ef7a34ee9f8dfafd1e31e78681c4dae00308110569004de53"
    sha256 cellar: :any,                 arm64_sequoia: "c588641d4892cc172f1a010403eb48dbbd8f592ac1563a5ba6dcacc94cad5866"
    sha256 cellar: :any,                 arm64_sonoma:  "c588641d4892cc172f1a010403eb48dbbd8f592ac1563a5ba6dcacc94cad5866"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6a09014b6883591c7acf5bac19ceed120dfdc6f5cd64718dbde5c9a146883eae"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ce35b3555e100ed345dd1b212431b435bf502f69e646a363f4246cbaa18db946"
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
