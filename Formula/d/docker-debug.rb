class DockerDebug < Formula
  desc "Use new container attach on already container go on debug"
  homepage "https://github.com/zeromake/docker-debug"
  url "https://github.com/zeromake/docker-debug/archive/refs/tags/v0.7.10.tar.gz"
  sha256 "5b7682acc6dcf93d9d260de88c269657348c4ef6db1ef184d794786509ba0af3"
  license "Apache-2.0"
  head "https://github.com/zeromake/docker-debug.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bb38bc8dd204bebeb1e7884035b7a2e3052793b8dea43daf65aed7b2d12e213d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "447b10635ca042525a1590e41f44dfa1a11180f1e2bbaaa66176e7c5f102bb10"
    sha256 cellar: :any_skip_relocation, ventura:       "c6afafa1dd8e74cf37428ac5ada20d97b97e400db98cefee89f23508dad5b68c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "816443d8ad4003344ca3db2508ad8b52673138bb7b84d0452a6fd7d51b8ae9e3"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/zeromake/docker-debug/version.Version=#{version}
      -X github.com/zeromake/docker-debug/version.GitCommit=#{tap.user}
      -X github.com/zeromake/docker-debug/version.BuildTime=#{time.iso8601}
      -X github.com/zeromake/docker-debug/version.PlatformName=#{tap.user}
    ]
    system "go", "build", *std_go_args(ldflags:), "./cmd/docker-debug"

    generate_completions_from_executable(bin/"docker-debug", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/docker-debug info")

    assert_match "\"TLS\": false", shell_output("#{bin}/docker-debug config")
  end
end
