class RailsMcpServer < Formula
  desc "MCP server for Rails applications"
  homepage "https://github.com/maquina-app/rails-mcp-server"
  url "https://github.com/maquina-app/rails-mcp-server/archive/refs/tags/v1.2.1.tar.gz"
  sha256 "61b678c95903f671b3915eaabe267cc873eabe0deeb6ca12bcb9b38c55283683"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9b891d1bb7c055b0b0bd958d1061ddeee9bbfb78c7e7641bfe366fffee886f6d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bcee3f7994494866f8f85b1295d9aefe0936ed49ffeac64c9a89a8f66a174455"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "afa8973952d89d40786ebb6e8f8a1056d7666add62d1cabab34e988677d05bd1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "448f862d8108cf4899e71da8a45a144c0ab69ec1763b363ceefae097fd5dc986"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "09361cfbf2a5ad9f665f02bfc12333af653040b21b1d98da0ab3bad2599275a4"
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
