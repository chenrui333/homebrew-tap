class Mcporter < Formula
  desc "TypeScript runtime and command-line toolkit for the Model Context Protocol"
  homepage "https://github.com/openclaw/mcporter"
  url "https://registry.npmjs.org/mcporter/-/mcporter-0.17.0.tgz"
  sha256 "219623e099f15783afdad24cc1de6b785a708e54054fd346839d2eff3c450a11"
  license "MIT"
  head "https://github.com/openclaw/mcporter.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any,                 arm64_tahoe:   "4972b314d5135494288c84c5651c1281b826a43e2a0f28d14206c9747f45bd0e"
    sha256 cellar: :any,                 arm64_sequoia: "4972b314d5135494288c84c5651c1281b826a43e2a0f28d14206c9747f45bd0e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9acbf85453d70f6e272d2a5cebdb4b34460d143553709bbaed059d3ccee3b341"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "232324edf59436fe6321e8f1135c211310846fbf7198fbbb5c75d410f0a70107"
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
