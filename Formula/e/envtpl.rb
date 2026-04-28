class Envtpl < Formula
  desc "Render Go templates on the command-line with shell environment variables"
  homepage "https://github.com/chenrui333/envtpl"
  url "https://github.com/chenrui333/envtpl/archive/refs/tags/v2.0.5.tar.gz"
  sha256 "ae7f12c22fd79174179e5173e36137da97b2999d734d68025ab39a200300f54e"
  license "MIT"
  head "https://github.com/chenrui333/envtpl.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7ff1339f6c830fe082d9a00c93e56471e04a282eeb731c3f1af5819e4cb0f651"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "631ac3be37626fcb7585be22d899a698e26c858950dd3f9028ca8a79b0a5669b"
    sha256 cellar: :any_skip_relocation, ventura:       "309d5c82c62099c93d4dd07e436039353417f504c1291cb152d94b79dbdffb4c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "30cb6947c567984dbde034e779b8b456374e00183f012add816fb95b41758327"
  end

  depends_on "go" => :build

  def install
    # https://goreleaser.com/customization/builds/go/
    ldflags = "-s -w -X main.version=#{version} -X main.commit=#{tap.user} -X main.date=#{time.iso8601}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/envtpl"
  end

  test do
    system bin/"envtpl", "--version"

    # test envtpl with a template file
    (testpath/"test.tmpl").write <<~EOS
      Hello, {{ .ENV_NAME }}!
    EOS
    assert_match "Hello, Homebrew!", shell_output("ENV_NAME=Homebrew #{bin}/envtpl test.tmpl")
  end
end
