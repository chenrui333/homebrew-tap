class Graphjin < Formula
  desc "Build NodeJS / GO APIs in 5 minutes not weeks"
  homepage "https://graphjin.com/"
  url "https://github.com/dosco/graphjin/archive/refs/tags/v3.14.2.tar.gz"
  sha256 "afbc3813b22f21009067c2a495ef5259dbc1110c111475406230b9c453553a3f"
  license "Apache-2.0"
  head "https://github.com/dosco/graphjin.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5dde7f07aa37e18d9894463cd0aa97bc072765b40cae5b5c7e26e309b45541f3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2d56c63c12a58a55478f60473817dc60ffb38cbe0a784b22ed381f5c5b2a6cfa"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2bfd9a1865b9d95b4f4a783f282658f5f4497385ab959c7a45f3fdb5ee1b9f1c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9bce72b4b749032bf909358a21253025358dddccdb0a9afc6e623126d3936258"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7ca150b911f4a15bd0f91fa6671b0d76940c0e9252b6ad9497f943c1dcf4f72c"
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

    system bin/"graphjin", "new", "myapp"
    assert_path_exists testpath/"myapp"
    assert_match "app_name: \"Myapp Development\"", (testpath/"myapp/dev.yml").read
  end
end
