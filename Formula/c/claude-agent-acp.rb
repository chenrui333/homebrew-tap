class ClaudeAgentAcp < Formula
  desc "Use Claude Code from any ACP client such as Zed!"
  homepage "https://github.com/zed-industries/claude-agent-acp"
  url "https://registry.npmjs.org/@zed-industries/claude-agent-acp/-/claude-agent-acp-0.23.1.tgz"
  sha256 "b3870a0ef60023360addcefc511225becb865efa085f2778b2c574889789e0cc"
  license "Apache-2.0"
  head "https://github.com/zed-industries/claude-agent-acp.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any,                 arm64_tahoe:   "a23ded2a9ef310d1be5fd743ed9f22cb4ae989e18e7d88b92f7ef88fed49712e"
    sha256 cellar: :any,                 arm64_sequoia: "a331793fc250f35719f8eb6b16bdb6bbdb1e4c3543e6c9c7325e1afd959b810e"
    sha256 cellar: :any,                 arm64_sonoma:  "a331793fc250f35719f8eb6b16bdb6bbdb1e4c3543e6c9c7325e1afd959b810e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6093a1729374674e72fb0233a69c16c82cd1e0f0f23037fb4636e0282c636662"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "32b7fe1ac8e04d601a00fdb9f9af875283f0f673c4f092f9c3f6042b62dd1be8"
  end

  depends_on "node"
  depends_on "ripgrep"

  def install
    system "npm", "install", *std_npm_args
    vendor_dir = libexec/"lib/node_modules/@zed-industries/claude-agent-acp" /
                 "node_modules/@anthropic-ai/claude-agent-sdk/vendor"

    %w[ripgrep audio-capture tree-sitter-bash].each do |dep|
      dep_dir = vendor_dir/dep
      rm_r dep_dir
    end

    arch = Hardware::CPU.intel? ? "x64" : Hardware::CPU.arch.to_s
    ripgrep_platform = "#{arch}-#{OS.kernel_name.downcase}"
    ripgrep_vendor_dir = vendor_dir/"ripgrep"
    platform_dir = ripgrep_vendor_dir/ripgrep_platform
    platform_dir.mkpath
    ln_s Formula["ripgrep"].opt_bin/"rg", platform_dir/"rg"
    bin.install_symlink libexec/"bin/claude-agent-acp"
  end

  test do
    require "open3"
    require "timeout"

    json = <<~JSON
      {"jsonrpc":"2.0","id":1,"method":"initialize","params":{"protocolVersion":1}}
    JSON

    Open3.popen3(bin/"claude-agent-acp") do |stdin, stdout, stderr, wait_thread|
      stdin.puts json
      stdin.flush

      output = +""
      Timeout.timeout(30) do
        until output.include?("\"protocolVersion\":1")
          ready = IO.select([stdout, stderr])
          ready[0].each do |io|
            chunk = io.readpartial(1024)
            output << chunk if io == stdout
          end
        end
      end
      assert_match "\"protocolVersion\":1", output
    ensure
      stdin.close unless stdin.closed?
      if wait_thread&.alive?
        begin
          Process.kill("TERM", wait_thread.pid)
        rescue Errno::ESRCH
          # Process already exited between alive? check and kill.
        end
      end
    end
  end
end
