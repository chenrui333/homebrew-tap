class Inbucket < Formula
  desc "Disposable webmail server with SMTP, POP3, and REST interfaces"
  homepage "https://inbucket.org/"
  url "https://github.com/inbucket/inbucket/archive/refs/tags/v3.2.0.tar.gz"
  sha256 "40035d9430da76d614bc6f09dc9c501bb857ed7b6d991c7374b9aea24d2e66ff"
  license "MIT"
  head "https://github.com/inbucket/inbucket.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0e61d534f87df02e80c6ab023cc80053b609e6d153973b300c29a4d349b31b28"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0e61d534f87df02e80c6ab023cc80053b609e6d153973b300c29a4d349b31b28"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a27f889bf6e3321f2c2423fe232e1018da69d55983626b9ad46b42f69e5c568a"
    sha256 cellar: :any,                 x86_64_linux:  "147ed29758b2dd3d360d97071683803771378930a04519dcd8134f6430fd9dff"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

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
