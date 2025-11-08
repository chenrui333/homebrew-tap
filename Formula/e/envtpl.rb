class Envtpl < Formula
  desc "Render Go templates on the command-line with shell environment variables"
  homepage "https://github.com/chenrui333/envtpl"
  url "https://github.com/chenrui333/envtpl/archive/refs/tags/v2.0.6.tar.gz"
  sha256 "1417578635f956d5f5b270613c15226fab2672b9ea317af6d08244653e372caa"
  license "MIT"
  head "https://github.com/chenrui333/envtpl.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6e4b1a1583a2b84dc9267d2ddac1d38e4a541fb75f3f032e54967d7c1694d4b0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6e4b1a1583a2b84dc9267d2ddac1d38e4a541fb75f3f032e54967d7c1694d4b0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6e4b1a1583a2b84dc9267d2ddac1d38e4a541fb75f3f032e54967d7c1694d4b0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6a0c0e7a087fe8017cd574d42fb25f33e76afaa0d1cc7c5a585f4bc007b94417"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0b38523b808d4f9defc72e2b0ff6f33731b9089cbdfd5fe1d626ab9701c0c697"
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
