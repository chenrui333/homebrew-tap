class Gitagent < Formula
  desc "Git-native AI agent with declarative tools, skills, and plugins"
  homepage "https://github.com/open-gitagent/gitagent"
  url "https://registry.npmjs.org/@open-gitagent/gitagent/-/gitagent-3.0.0.tgz"
  sha256 "dc48dd043d17b1dd362b876dbd3bdbee6a9e57eed1a3dfceaea75f8538bcb301"
  license "MIT"
  head "https://github.com/open-gitagent/gitagent.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "519e713bf1dde8b18e43a99a1be305f32ddaf2d94413e6921a9eb8e5e0821819"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "519e713bf1dde8b18e43a99a1be305f32ddaf2d94413e6921a9eb8e5e0821819"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "30885ce8f824c4faf89cd10859f9942fbea926d68f96bf040a49c6d6a40c4945"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "558b0029ec4ad5890bfebfb5d3bb671561f201c1c78c6b111cd1d6f97a89a3fd"
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
