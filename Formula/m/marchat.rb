class Marchat < Formula
  desc "Terminal chat with WebSockets, E2E encryption, plugins, and file sharing"
  homepage "https://github.com/Cod-e-Codes/marchat"
  url "https://github.com/Cod-e-Codes/marchat/archive/refs/tags/v1.3.3.tar.gz"
  sha256 "9bc2ddd67a68c0baeefcb54c9ba58d1b98b2886608bb9fbe7bad7b39a5e43a22"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b029ce94a8ad08066b1f5d78c475dcee451b9b8bf41a8abea2ff5bb0724c4c06"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b029ce94a8ad08066b1f5d78c475dcee451b9b8bf41a8abea2ff5bb0724c4c06"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b029ce94a8ad08066b1f5d78c475dcee451b9b8bf41a8abea2ff5bb0724c4c06"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e218211333cd7ab0d7efe3de2bfe04740e77af174fb932daa120b65a4fa61774"
    sha256 cellar: :any,                 x86_64_linux:  "a4226c679657a2b81f26a40508b7b919c18b95cb100178221f99636771c5a986"
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
