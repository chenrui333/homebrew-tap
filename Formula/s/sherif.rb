class Sherif < Formula
  desc "Opinionated, zero-config linter for JavaScript monorepos"
  homepage "https://github.com/QuiiBz/sherif"
  url "https://registry.npmjs.org/sherif/-/sherif-1.6.1.tgz"
  sha256 "416172fbd1ec78120e8f90a8fb195a87030c2326a8ec3fd28d0af72aa51ecf68"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8bb0631dc3db5373b9629c76339da415bdbbfacb9aa191587802eab04221bb1e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "662dbb308b3a6921bc8fc5740273f9852cb7ed1444eb35fb444b131e2bd2a0cb"
    sha256 cellar: :any_skip_relocation, ventura:       "76ee21b771aea074c18dba46473541598e7895f24c90127bc08416cdc27d1e32"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1ea307f60c59f7c0401d8d51ca49db5295947026b881d51f02d42ad66d235fbd"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    (testpath/"package.json").write <<~JSON
      {
        "name": "test",
        "version": "1.0.0",
        "private": true,
        "packageManager": "npm",
        "workspaces": [ "." ]
      }
    JSON
    (testpath/"test.js").write <<~JS
      console.log('Hello, world!');
    JS
    assert_match "No issues found", shell_output("#{bin}/sherif --no-install .")
  end
end
