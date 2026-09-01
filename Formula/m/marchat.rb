class Marchat < Formula
  desc "Terminal chat with WebSockets, E2E encryption, plugins, and file sharing"
  homepage "https://github.com/Cod-e-Codes/marchat"
  url "https://github.com/Cod-e-Codes/marchat/archive/refs/tags/v1.3.6.tar.gz"
  sha256 "70e8e8dcd9364587c17f5637b297a343bf7db208ffa25b65d6756ce6875411d2"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7b114524ec13a3ed74b2db2ef9994e1ce731d236108947d473e45121db6f03bb"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7b114524ec13a3ed74b2db2ef9994e1ce731d236108947d473e45121db6f03bb"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7b114524ec13a3ed74b2db2ef9994e1ce731d236108947d473e45121db6f03bb"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "35a040d1239ef3c029fa055f390359d5221b297663f83464c09570fd7435aa3d"
    sha256 cellar: :any,                 x86_64_linux:  "da6d9b2d92f32f308f8b7afc84d8d85089a16a796441b29c17fdd21b0e64c6b4"
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
