class RailsMcpServer < Formula
  desc "MCP server for Rails applications"
  homepage "https://github.com/maquina-app/rails-mcp-server"
  url "https://github.com/maquina-app/rails-mcp-server/archive/refs/tags/v1.2.2.tar.gz"
  sha256 "5383902c2efcae00f3d6edd83b14db2cd926844ce01d62cd3fdbce989f5dfb29"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "071ac2152adb5ba56323215d05b0985470cfed13478cf4b903641756275d4034"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "11c6f00e412c15d70c76fb01260b2331f67e22b3743a10cb45393cdd584c9876"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0f1f5c3128fa6edea3fc6e60f216466af15e78f40ccb847c2096b4bd860fd68a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "322e3d2275bbd3e770f08370f5b0aa3d2fbc9bad9265d811b4071344a3e748cf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0ed4dc18f864d2d641e1d3cf39f9cc054508c8d4313968a62f7117df68810f20"
  end

  depends_on "ruby"

  def install
    ENV["BUNDLE_VERSION"] = "system" # Avoid installing Bundler into the keg
    ENV["GEM_HOME"] = libexec

    system "bundle", "config", "set", "without", "development", "test"
    system "bundle", "install"
    system "gem", "build", "#{name}.gemspec"
    system "gem", "install", "#{name}-#{version}.gem"

    bin.install libexec/"bin/rails-mcp-server"
    bin.env_script_all_files(libexec/"bin", GEM_HOME: ENV["GEM_HOME"])
  end

  test do
    (testpath/".config/rails-mcp/projects.yml").write <<~YAML
      projects:
        - name: test
          path: #{testpath}
    YAML

    json = <<~JSON
      {"jsonrpc":"2.0","id":1,"method":"initialize","params":{"protocolVersion":"2025-06-18"}}
      {"jsonrpc":"2.0","method":"notifications/initialized","params":{}}
      {"jsonrpc":"2.0","id":2,"method":"tools/list","params":{"cursor":null}}
    JSON

    output = pipe_output("#{bin}/rails-mcp-server 2>&1", json, 0)
    assert_match "Change the active Rails project to interact with a different codebase", output
  end
end
