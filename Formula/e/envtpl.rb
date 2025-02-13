class Envtpl < Formula
  desc "Render Go templates on the command-line with shell environment variables"
  homepage "https://github.com/chenrui333/envtpl"
  url "https://github.com/chenrui333/envtpl/archive/refs/tags/v2.0.4.tar.gz"
  sha256 "162e968db5149c57996d79b38ae78ccebb6b551a16d77cc3075c2ba897b68fdb"
  license "MIT"
  head "https://github.com/chenrui333/envtpl.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9b00a47e00a390501efbeeccbfc12e20dce623b1f5acb2b35bb1a33528caaf70"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fcd47cbb6971e5014da4c7debfc8641b87acd67544aea9c1cbea3ceed106caa6"
    sha256 cellar: :any_skip_relocation, ventura:       "8fc5ea51cd9c20d8fab76a7e993f2a529c69b25c4ae1bc4623238599e494c5d3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "910e79b81965929d29cf77926dbdd10d7806d3ebfc3e6b501604cd216376b863"
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
