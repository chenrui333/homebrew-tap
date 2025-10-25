class Knip < Formula
  desc "Declutter your JavaScript & TypeScript projects"
  homepage "https://knip.dev/"
  url "https://registry.npmjs.org/knip/-/knip-5.66.3.tgz"
  sha256 "2ab15c0bfe2a7c9e0388629d5de8b71b9d351c93e27577adb7e2eea282ad3801"
  license "ISC"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any,                 arm64_tahoe:   "27abf0f6ef35c4a2c14a3307e6c16591c6ac0a6bda604a575ee41f628faf200e"
    sha256 cellar: :any,                 arm64_sequoia: "59445c1b386d9175f1c570bd33799986c89238c8cf808b498b1dc9430715de6e"
    sha256 cellar: :any,                 arm64_sonoma:  "59445c1b386d9175f1c570bd33799986c89238c8cf808b498b1dc9430715de6e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f2dfcd2d178076a4703a2d7f30f7bab02d570b6da352512e9064e6d9a8d9d014"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7b3ace881f99cb143660598e14c8856c89bc465ea832cc3590b01b8851170160"
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
