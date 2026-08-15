class Marchat < Formula
  desc "Terminal chat with WebSockets, E2E encryption, plugins, and file sharing"
  homepage "https://github.com/Cod-e-Codes/marchat"
  url "https://github.com/Cod-e-Codes/marchat/archive/refs/tags/v1.3.5.tar.gz"
  sha256 "efe8e2b9a302ef9dbaf636ac130ff0039e2026995c51ed6a022287a4c52a63c2"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "fae9a5b8b5c8ea9f0ccdd3889f7bf85052f5ea260b60540eb4c7fa864524306b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fae9a5b8b5c8ea9f0ccdd3889f7bf85052f5ea260b60540eb4c7fa864524306b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fae9a5b8b5c8ea9f0ccdd3889f7bf85052f5ea260b60540eb4c7fa864524306b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ac54066ca6e495e4087462e6646b7c30ca322e46d9fe7f76c30b12596fa3dacc"
    sha256 cellar: :any,                 x86_64_linux:  "67d7cc719994822844a6865129ea2310dfec579072a6c932d9aca52a65c11a9f"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/Cod-e-Codes/marchat/shared.ClientVersion=#{version}
      -X github.com/Cod-e-Codes/marchat/shared.ServerVersion=#{version}
      -X github.com/Cod-e-Codes/marchat/shared.BuildTime=#{time.iso8601}
      -X github.com/Cod-e-Codes/marchat/shared.GitCommit=#{tap.user}
    ]
    system "go", "build", *std_go_args(ldflags:), "./cmd/server"
  end

  test do
    ENV["MARCHAT_ADMIN_KEY"] = "your-generated-key"
    ENV["MARCHAT_USERS"] = "admin1,admin2"

    output_log = testpath/"output.log"
    pid = spawn bin/"marchat", testpath, [:out, :err] => output_log.to_s
    sleep 1
    assert_match version.to_s, output_log.read
    assert_match(/TLS:.*Disabled/m, output_log.read)
  ensure
    Process.kill("TERM", pid)
    Process.wait(pid)
  end
end
