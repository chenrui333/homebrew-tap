class Mcporter < Formula
  desc "TypeScript runtime and command-line toolkit for the Model Context Protocol"
  homepage "https://github.com/openclaw/mcporter"
  url "https://registry.npmjs.org/mcporter/-/mcporter-0.17.1.tgz"
  sha256 "23de7f9447c33a54ca04ce8dea80c2b96cdf9e3b4842b0ead21d61f04da48a31"
  license "MIT"
  head "https://github.com/openclaw/mcporter.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any,                 arm64_tahoe:   "8df8f323c1b8b4d452b448b8a6a2b6cea0a774fa2a3be9b4d54e33212605a10f"
    sha256 cellar: :any,                 arm64_sequoia: "8df8f323c1b8b4d452b448b8a6a2b6cea0a774fa2a3be9b4d54e33212605a10f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f36ccfb6b6635096b5f26953b8c9ca4aed9881ada3789c4330b5a44ec1df5b8d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "452f9370995acbef2a1882f52a5e89b9fd7e84501d4bb8cb5b273897c9967c53"
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

    node_modules = libexec/"lib/node_modules/mcporter/node_modules"
    os = OS.kernel_name.downcase
    arch = Hardware::CPU.intel? ? "x64" : Hardware::CPU.arch.to_s
    native = "#{os}-#{arch}#{"-gnu" if OS.linux?}"
    node_modules.glob("**/@rolldown/binding-*").each do |dir|
      rm_r(dir) if dir.basename.to_s != "binding-#{native}"
    end

    bin.install_symlink libexec.glob("bin/*")
  end

  service do
    run [opt_bin/"mcporter", "daemon", "start", "--foreground"]
    keep_alive true
    log_path var/"log/mcporter.log"
    error_log_path var/"log/mcporter.log"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/mcporter --version")

    config = testpath/"mcporter.json"
    config.write '{"mcpServers":{},"imports":[]}'
    node = formula_opt_bin("node")/"node"
    output = shell_output("#{bin}/mcporter --config #{config} config add brew-test --command #{node}")
    assert_match "Added 'brew-test'", output
    servers = JSON.parse(shell_output("#{bin}/mcporter --config #{config} config list --json")).fetch("servers")
    assert_equal "brew-test", servers.fetch(0).fetch("name")
    assert_equal "stdio", servers.fetch(0).fetch("transport")
    assert_equal node.to_s, servers.fetch(0).fetch("command")
  end
end
