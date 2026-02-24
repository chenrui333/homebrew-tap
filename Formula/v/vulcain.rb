class Vulcain < Formula
  desc "Fast and idiomatic client-driven REST APIs"
  homepage "https://vulcain.rocks/"
  url "https://github.com/dunglas/vulcain/archive/refs/tags/v1.3.0.tar.gz"
  sha256 "22befb760ec4f052b6cf849b27628f88341e2926c9fb9dcdbeafd75527e01412"
  license "AGPL-3.0-only"
  head "https://github.com/dunglas/vulcain.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "56438a56caabda5f461a6f39238405d410db2c27f69bdc41e6d487a9cdbf5e6d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "57e80968d9ceb9e06efb8947537aa35b4aa538e25be47c0613b3c007e07f2d71"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "821c782314e3a0c9fbed36064e907da49bc48bdb0b1a6085ea4f0706661bd55a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "acce41d28e5b70c400a3e3189584077b81a03204b2ad962f742d04642b445903"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a172aa757729de2f6360cb57e7ad0184a5e8fa139d5f7de6a153fafdc3509ae0"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/caddyserver/caddy/v2.CustomVersion=Vulcain.rocks.#{version}"

    cd "caddy" do
      system "go", "build", *std_go_args(ldflags:, tags: "nobadger,nomysql,nopgx"), "./vulcain"
    end
  end

  test do
    port = free_port

    assert_match version.to_s, shell_output("#{bin}/vulcain version")

    (testpath/"Caddyfile").write <<~EOS
      http://127.0.0.1:#{port} {
        respond "Vulcain API"
      }
    EOS

    pid = spawn bin/"vulcain", "run", "--config", testpath/"Caddyfile"

    sleep 2

    assert_match "Vulcain API", shell_output("curl -s http://127.0.0.1:#{port}")
  ensure
    Process.kill("TERM", pid)
    Process.wait(pid)
  end
end
