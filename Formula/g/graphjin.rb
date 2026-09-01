class Graphjin < Formula
  desc "Build NodeJS / GO APIs in 5 minutes not weeks"
  homepage "https://graphjin.com/"
  url "https://github.com/dosco/graphjin/archive/refs/tags/v3.20.73.tar.gz"
  sha256 "a66c6bdd75eb38b4373a8579ad78f1c556056a8468ac39ab61275e1c98dfb28c"
  license "Apache-2.0"
  head "https://github.com/dosco/graphjin.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "579329444c030d6781d2cb9f18d2c33bf58b4abd24c5a17291658b465acd7f27"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "24988eb9f5a2dd9d70a165ecd26ed7d45d49a920ccf494f3c964748bc8b85b8f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "941d1959bc237eed791ed63f9017c16c048d9a37873f78665a988a83f2ce96e9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "bbed71445483e6470a015830fcb7951825663df30a4d16f28b863f60ebeca06c"
    sha256 cellar: :any,                 x86_64_linux:  "6c93d172fba69f86ded13d57973bdc7806886176d43e5da88bd365d651b545ed"
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
