class Knip < Formula
  desc "Declutter your JavaScript & TypeScript projects"
  homepage "https://knip.dev/"
  url "https://registry.npmjs.org/knip/-/knip-6.14.1.tgz"
  sha256 "6bd76195ef01aa5784aef5eb82bcd3d6e6f763a1cf11ab7206ae28b4e1ab36b4"
  license "ISC"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any,                 arm64_tahoe:   "fa67a6cd568a8817e96ff8e192bfc6e3796494f0c7ce421c065b2b1e1b01fb72"
    sha256 cellar: :any,                 arm64_sequoia: "f66db8d5bfaa1eeda3696eac7fe2bdb8ff6ef0f439f5949f77a1b15d121b2661"
    sha256 cellar: :any,                 arm64_sonoma:  "f66db8d5bfaa1eeda3696eac7fe2bdb8ff6ef0f439f5949f77a1b15d121b2661"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3367da6a54edd9daf95992558a96adbb64b411bdac055e9d58ccc0e5b90b483e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ab412640238c74a9c0fbe98b624c2be1c09ff556e727c5b6bfea2c02b689a0c9"
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
