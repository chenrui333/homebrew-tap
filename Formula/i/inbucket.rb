class Inbucket < Formula
  desc "Disposable webmail server with SMTP, POP3, and REST interfaces"
  homepage "https://inbucket.org/"
  url "https://github.com/inbucket/inbucket/archive/refs/tags/v3.1.1.tar.gz"
  sha256 "d985f7a9e0c739146e83c0f173c00b74e4b32c136e3019a600fe8869505bbc71"
  license "MIT"
  head "https://github.com/inbucket/inbucket.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "75ba55762825487122d7cbdd8ece14b43428e6437c67d13a69e37a5c3444a489"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "75ba55762825487122d7cbdd8ece14b43428e6437c67d13a69e37a5c3444a489"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "75ba55762825487122d7cbdd8ece14b43428e6437c67d13a69e37a5c3444a489"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c581d14094c75dedc73704d01c77a727ef407f093eaa00cecd0f874260a79a08"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2dfdf74ea04c3de5da52fd41bf3863902f1d087ab411caadb66a9ead308f5fce"
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
