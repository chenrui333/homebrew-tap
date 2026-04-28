class Marchat < Formula
  desc "Terminal chat with WebSockets, E2E encryption, plugins, and file sharing"
  homepage "https://github.com/Cod-e-Codes/marchat"
  url "https://github.com/Cod-e-Codes/marchat/archive/refs/tags/v0.6.0-beta.3.tar.gz"
  sha256 "37741caa85abdffe83d8f4097099394777b1ee5ee2c915b5e641c2cb915539f8"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "db6cb7d96085408f47f9db29deb5fbb7463487cf5cbfa5941b9218b657b6dc03"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "eaba7d98e2658cfeeb79275d0ad1716355f2a38b0e162dcbdf53520de1cf3de4"
    sha256 cellar: :any_skip_relocation, ventura:       "885470a2bb885a05222aadfe7f26f10b2dbbc41c9cd1c76085dd05aeda9fb5c2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "99d7df95e8a52e6ff6c6288a74b4c3cf48668ab2353e7b7b8edf7e803f79d44f"
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
    assert_match "Starting server without TLS on :8080", output_log.read
  ensure
    Process.kill("TERM", pid)
    Process.wait(pid)
  end
end
