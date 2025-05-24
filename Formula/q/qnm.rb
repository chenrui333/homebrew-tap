class Qnm < Formula
  desc "Cli utility for querying the node_modules directory"
  homepage "https://github.com/ranyitz/qnm"
  url "https://registry.npmjs.org/qnm/-/qnm-2.10.4.tgz"
  sha256 "205044b4bbc4637917ac55f936c17b2763e622040cfa84acb1a0289b50b21098"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3547a40ae4fb9b63a789e9fe9093bb5b0904e030d5396e4e06037e2d7a34b4ca"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4a3c013b244bb4515d8e687f81df3d51de95fba4d068c5d93efe68848c277b21"
    sha256 cellar: :any_skip_relocation, ventura:       "b4263ac8fd2bc23e9387c8f39fd13bbf8cff202e02be5ece78a835770d8e5742"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "04cdb543da4d353fcb2c5d32a3ef4fc2cafbd937d30e3832177e1fcd9438befd"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/qnm --version")

    (testpath/"package.json").write <<~EOS
      {
        "name": "test",
        "version": "0.0.1",
        "dependencies": {
          "lodash": "^4.17.21"
        }
      }
    EOS

    # Simulate a node_modules directory with lodash to avoid `npm install`
    (testpath/"node_modules/lodash/package.json").write <<~EOS
      {
        "name": "lodash",
        "version": "4.17.21"
      }
    EOS

    # Disable remote fetch with `--no-remote`
    output = shell_output("#{bin}/qnm --no-remote lodash")
    assert_match "lodash", output
  end
end
