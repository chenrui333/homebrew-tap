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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6025ef60071f6f4a00fde5c2228472bd51059e6d77095f024656ce2686713e19"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6025ef60071f6f4a00fde5c2228472bd51059e6d77095f024656ce2686713e19"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6025ef60071f6f4a00fde5c2228472bd51059e6d77095f024656ce2686713e19"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "89128c77763d1382c29c090b96995d4fcfee0fa17b151acb629db2446972c7ad"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "987f58362319dccf2c05866fade24a032c2bdb766fa8f86ba80b5844ed5c3402"
  end

  depends_on "go" => :build

  def install
    ENV["CGO_ENABLED"] = "0" if OS.linux? && Hardware::CPU.arm?

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
