class Mcporter < Formula
  desc "TypeScript runtime and command-line toolkit for the Model Context Protocol"
  homepage "https://github.com/openclaw/mcporter"
  url "https://registry.npmjs.org/mcporter/-/mcporter-0.16.1.tgz"
  sha256 "b6c2d9a9c00a429f59c7cc721f15d2b34a08b62c2deab7910483ef996a1277da"
  license "MIT"
  head "https://github.com/openclaw/mcporter.git", branch: "main"

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
