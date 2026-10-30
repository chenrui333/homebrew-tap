class Gitagent < Formula
  desc "Git-native AI agent with declarative tools, skills, and plugins"
  homepage "https://github.com/open-gitagent/gitagent"
  url "https://registry.npmjs.org/@open-gitagent/gitagent/-/gitagent-2.2.0.tgz"
  sha256 "d054b85e74eda87bafcdc6740a175b80e731318406780f15f9466d35bb6d5af8"
  license "MIT"
  head "https://github.com/open-gitagent/gitagent.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, all: "c8ebd151709af429cae7eba39e1f52c0a01362f086239ace43edf0909b1ba55e"
  end

  depends_on "node"

  deny_network_access!

  def prepare_package_json
    package_json = JSON.parse((buildpath/"package.json").read)
    package_json.delete("devDependencies")
    (buildpath/"package.json").atomic_write(JSON.pretty_generate(package_json))
  end

  def fetch
    prepare_package_json
    system "npm", "install", *std_npm_args(prefix: buildpath/"npm-fetch")
  end

  def install
    prepare_package_json
    rm_r buildpath/"npm-fetch" if (buildpath/"npm-fetch").exist?
    system "npm", "install", "--offline", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    # FIXME: Upstream has no version command; --version starts a session, so check the installed package metadata.
    package = libexec/"lib/node_modules/@open-gitagent/gitagent/package.json"
    assert_equal version.to_s, shell_output("node -p \"require('#{package}').version\"").strip

    (testpath/"plugins/brew-test/plugin.yaml").write <<~YAML
      id: brew-test
      name: Homebrew test plugin
      version: 1.0.0
      description: Local plugin discovery fixture
    YAML
    output = shell_output("#{bin}/gitagent plugin list --dir #{testpath}")
    assert_match "brew-test", output
    assert_match "Local plugin discovery fixture", output
  end
end
