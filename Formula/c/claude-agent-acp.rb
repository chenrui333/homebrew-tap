class ClaudeAgentAcp < Formula
  desc "Use Claude Code from any ACP client such as Zed!"
  homepage "https://github.com/zed-industries/claude-agent-acp"
  url "https://registry.npmjs.org/@zed-industries/claude-agent-acp/-/claude-agent-acp-0.22.2.tgz"
  sha256 "780ff4aa3dac8f120abeec1f3b3a575a56c25b9647441c52090bf0b1f3a265ea"
  license "Apache-2.0"
  head "https://github.com/zed-industries/claude-agent-acp.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any,                 arm64_tahoe:   "6017dc681aefceb79ecfb2444dec120adcf0bdb0c59a6391dbecfb51e466a0a4"
    sha256 cellar: :any,                 arm64_sequoia: "6442326829434314a77c7a6164a77c07076f091d74eb5ca1c6ae42c1875eeabf"
    sha256 cellar: :any,                 arm64_sonoma:  "6442326829434314a77c7a6164a77c07076f091d74eb5ca1c6ae42c1875eeabf"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7cbc227a1444a76887475d1db42e09d11a0ccf31f85ad5d8ee7fdddf3d8f1575"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bc837cd486a2e5ced44acd892948f9fe2046a967bcb08960ddc78caf884420c6"
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
