class Vulcain < Formula
  desc "Fast and idiomatic client-driven REST APIs"
  homepage "https://vulcain.rocks/"
  url "https://github.com/dunglas/vulcain/archive/refs/tags/v1.2.1.tar.gz"
  sha256 "43373612fa073dcbe73a70a2f50230797f4b159bdbe2be7f6f69701363fd697a"
  license "AGPL-3.0-only"
  head "https://github.com/dunglas/vulcain.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a6c6af6b342e0eadbf7eb50f1d8a05c78c25934f00d88da5373a22f036817827"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c0e4c5df09031d858959bc131f6809a564c3f622fd7bfd3a3ab3f74368db0402"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f954753047be190c58d4bbfb466b2844b168a7242d2f0ded96d783b021fae60c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9a3d38d33fdc7c473bb4eaaf0527893a71cba81efa3148cfb749af1550ad978d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b0e66d1d2c10a594e3b3f1c23018a4858e4a7172d625cc29131f451a137dd632"
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
