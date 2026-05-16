class Graphjin < Formula
  desc "Build NodeJS / GO APIs in 5 minutes not weeks"
  homepage "https://graphjin.com/"
  url "https://github.com/dosco/graphjin/archive/refs/tags/v3.18.20.tar.gz"
  sha256 "a4403785d9c53f4cd98a9508e78988fbb31af535d06b276498e9a205f7ebe317"
  license "Apache-2.0"
  head "https://github.com/dosco/graphjin.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "04a5c4f7fbd6a16f0ab156bfd49e10a9e1515a2365db544c9da442e87be3dc00"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0b82876aa79a3be0f443241b6ab36adcdc322191cd20b933f33e967465ad33bf"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d28dce0057bea3c2350a38e61dac0c53d5423fb4668d49ef76d12c5cd0ee8497"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a21f63189067c5e4a8744b1655b2d7fcd6957e5ee8efdd82df3f17125d504498"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "215f14b4d421da3eca6214263fe51e42e16a66e67d91e4d42a4dd1ae850749e7"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X main.version=#{version}
      -X main.commit=#{tap.user}
      -X main.date=#{time.iso8601}
      -X github.com/dosco/graphjin/serv/v3.version=#{version}
    ]

    cd "cmd" do
      system "go", "build", *std_go_args(ldflags:)
    end

    generate_completions_from_executable(bin/"graphjin", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/graphjin version")

    system bin/"graphjin", "serve", "new", "myapp"
    assert_path_exists testpath/"myapp"
    assert_match "app_name: \"Myapp Development\"", (testpath/"myapp/dev.yml").read
  end
end
