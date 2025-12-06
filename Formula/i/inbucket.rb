class Inbucket < Formula
  desc "Disposable webmail server with SMTP, POP3, and REST interfaces"
  homepage "https://inbucket.org/"
  url "https://github.com/inbucket/inbucket/archive/refs/tags/v3.1.1.tar.gz"
  sha256 "d985f7a9e0c739146e83c0f173c00b74e4b32c136e3019a600fe8869505bbc71"
  license "MIT"
  head "https://github.com/inbucket/inbucket.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4b39a8bfbcbfb459368bee731be9787b814ffc817caeeceaae35a48ed8595985"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4b39a8bfbcbfb459368bee731be9787b814ffc817caeeceaae35a48ed8595985"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4b39a8bfbcbfb459368bee731be9787b814ffc817caeeceaae35a48ed8595985"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "64228e2461b71b1b1a7b312120914f70cab9288b309dd2f076568b2d283e94de"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "278c751b0dc48193e60c2b46b46304de30fc01ad87bb5b80d358f5a752338e35"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.version=#{version} -X main.commit=#{tap.user} -X main.date=#{time.iso8601}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/inbucket"
    system "go", "build", *std_go_args(ldflags:, output: bin/"inbucket-client"), "./cmd/client"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/inbucket --version")
    output = shell_output("#{bin}/inbucket-client list test 2>&1", 1)
    assert_match "Couldn't build client: parse \"http://%slocalhost:9000\"", output
  end
end
