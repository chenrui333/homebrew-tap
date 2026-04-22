class Knip < Formula
  desc "Declutter your JavaScript & TypeScript projects"
  homepage "https://knip.dev/"
  url "https://registry.npmjs.org/knip/-/knip-6.6.0.tgz"
  sha256 "5a500a5039ec34fbebfb35d6d27c54c5c0f09e3737f4b2da2222f8a215d8fdf3"
  license "ISC"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any,                 arm64_tahoe:   "fb5b842802b5b586f109088f7b9801a5f793fca1f9b6a93e6b546006566c79d9"
    sha256 cellar: :any,                 arm64_sequoia: "88aced2c26bc5138805ab3b172751155acb96b945b8d3d59ca3ceb927aac1d98"
    sha256 cellar: :any,                 arm64_sonoma:  "88aced2c26bc5138805ab3b172751155acb96b945b8d3d59ca3ceb927aac1d98"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5876974967deecbbcb581d6f91b8ac06605dd79982396c0b22e53e797efe5f2c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "54aa14d3e1535820c8eaac3de73df3f93adcd51dc91c5cd9b76f37e1ecf9d995"
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
