class Qnm < Formula
  desc "Cli utility for querying the node_modules directory"
  homepage "https://github.com/sorenlouv/qnm"
  url "https://registry.npmjs.org/qnm/-/qnm-2.10.4.tgz"
  sha256 "205044b4bbc4637917ac55f936c17b2763e622040cfa84acb1a0289b50b21098"
  license "MIT"

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
