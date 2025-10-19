class Envtpl < Formula
  desc "Render Go templates on the command-line with shell environment variables"
  homepage "https://github.com/chenrui333/envtpl"
  url "https://github.com/chenrui333/envtpl/archive/refs/tags/v2.0.5.tar.gz"
  sha256 "ae7f12c22fd79174179e5173e36137da97b2999d734d68025ab39a200300f54e"
  license "MIT"
  revision 1
  head "https://github.com/chenrui333/envtpl.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "280d597c06349747ae9c78c3dab386d850be2f4c916e115d382b1773e8582038"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "280d597c06349747ae9c78c3dab386d850be2f4c916e115d382b1773e8582038"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "280d597c06349747ae9c78c3dab386d850be2f4c916e115d382b1773e8582038"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "097eb9481b89356b24c210df44572c0106fcf9a904af9b3b5effc83b10876c53"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7e72dd014b27fbd20b8333d8a1d3ac179e63b513790a88696b49e35bfb98cfb0"
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
