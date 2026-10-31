class PiAcp < Formula
  desc "Agent Client Protocol adapter for the Pi coding agent"
  homepage "https://github.com/svkozak/pi-acp"
  url "https://registry.npmjs.org/pi-acp/-/pi-acp-0.0.34.tgz"
  sha256 "4b3bf6bc71bed2b7f43dd7fcfa1906e464828e471740da593107e4f1608f2650"
  license "MIT"
  head "https://github.com/svkozak/pi-acp.git", branch: "main"

  depends_on "node"
  depends_on "pi-coding-agent"

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
    (bin/"pi-acp").write_env_script libexec/"bin/pi-acp",
                                   PATH: "#{formula_opt_bin("pi-coding-agent")}:$PATH"
  end

  test do
    require "open3"
    require "timeout"

    # The adapter reports its version through ACP initialize, not a CLI flag.
    request = {
      jsonrpc: "2.0",
      id:      1,
      method:  "initialize",
      params:  { protocolVersion: 1, clientCapabilities: {} },
    }
    Open3.popen3(bin/"pi-acp") do |stdin, stdout, _stderr, wait_thread|
      stdin.puts request.to_json
      stdin.flush
      response = JSON.parse(Timeout.timeout(30) { stdout.readline })
      assert_equal version.to_s, response.dig("result", "agentInfo", "version")
      assert_equal 1, response.dig("result", "protocolVersion")
      assert_equal true, response.dig("result", "agentCapabilities", "loadSession")
      assert_equal "pi_terminal_login", response.dig("result", "authMethods", 0, "id")
    ensure
      stdin.close unless stdin.closed?
      if wait_thread&.alive?
        begin
          Process.kill("TERM", wait_thread.pid)
        rescue Errno::ESRCH
          # The adapter may have already exited after stdin closed.
        end
      end
    end
  end
end
