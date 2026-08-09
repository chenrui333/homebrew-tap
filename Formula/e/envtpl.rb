class Envtpl < Formula
  desc "Render Go templates on the command-line with shell environment variables"
  homepage "https://github.com/chenrui333/envtpl"
  url "https://github.com/chenrui333/envtpl/archive/refs/tags/v2.0.7.tar.gz"
  sha256 "e6d212e203ef595679ff0ebd01177839252fcaec4a97508815d5236f8d0dff96"
  license "MIT"
  head "https://github.com/chenrui333/envtpl.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7c6a6984d6df39da37eb85ecec90eaefdeac026d5f066239b0d4b178315236d8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7c6a6984d6df39da37eb85ecec90eaefdeac026d5f066239b0d4b178315236d8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7c6a6984d6df39da37eb85ecec90eaefdeac026d5f066239b0d4b178315236d8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d7bc8807ea9efcb7e39b97d89c130d57f96159e66b4c09fd277815703a53e5a0"
    sha256 cellar: :any,                 x86_64_linux:  "341e3402ae455bd7bd0704544247870e045da6e62b15a18b49f265f22f49386a"
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
