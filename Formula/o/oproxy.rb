class Oproxy < Formula
  desc "Open-source MITM proxy to intercept, inspect, and mock network traffic"
  homepage "https://github.com/sauravrao637/oproxy"
  url "https://github.com/sauravrao637/oproxy/archive/refs/tags/v0.1.6.tar.gz"
  sha256 "0282e6ad610367f8b70d17478648a8c295591292e4c86c5160bcb538100a89de"
  license "MIT"
  head "https://github.com/sauravrao637/oproxy.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "467e79a5b81ab258b77b2195cd747c73fb672b6e8c54b8d563521e13b6e81222"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "275eb25eb0fd55fca027471b53e5a0cc7af7e71423446a81be4b4de3407d75eb"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0b42e1702ea032be4ff3278e7ab9d1bd45033ab7703ce8eae7abd50158de333c"
    sha256 cellar: :any,                 arm64_linux:   "4443c43ee021ebd102bdc221d180c224ec73d5c2a3b576f100d887782996ab94"
    sha256 cellar: :any,                 x86_64_linux:  "bbfbd0f74e0d20c2fb4ba9a05564fe27db1282fe62619709a9b6db8018ed1b01"
  end

  depends_on "node" => :build
  depends_on "rust" => :build

  def install
    cd "src/design" do
      system "npm", "install", *std_npm_args(prefix: false, ignore_scripts: false)
      system "node", "build.mjs"
    end

    system "cargo", "install", *std_cargo_args
  end

  test do
    port = free_port
    config = testpath/"config.yaml"
    config.write <<~YAML
      port: #{port}
      mitm:
        enabled: false
        root_ca_path: #{testpath}/certs
      storage_path: #{testpath}/storage
    YAML

    ENV["OPROXY_CONFIG"] = config.to_s

    pid = spawn bin/"oproxy"
    sleep 3

    output = shell_output("curl -s http://127.0.0.1:#{port}/health")
    assert_match '"status":"ok"', output
    assert_path_exists testpath/"certs/root.crt"
  ensure
    Process.kill("TERM", pid) if pid
  end
end
