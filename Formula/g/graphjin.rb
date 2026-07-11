class Graphjin < Formula
  desc "Build NodeJS / GO APIs in 5 minutes not weeks"
  homepage "https://graphjin.com/"
  url "https://github.com/dosco/graphjin/archive/refs/tags/v3.18.43.tar.gz"
  sha256 "5142ea1fbed3d3bd7baec084d733b02d84a77e0be691e395ae9922835a1beb63"
  license "Apache-2.0"
  head "https://github.com/dosco/graphjin.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "410d40ec1b017c699cc9504b6027dbcc79d0a0640e7cb797ba4d789c03deaa86"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3e517e9e6f400e42f9ce9c98156ba4fa9c5aeda0cf2f42134405e4f2addea5be"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3ef9dde742c8a6d2ff956067c8b98aaab116dc04e404cff73e784d1214d0d36a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "aee817e46fd3cef58316fc8738eb7fafcb6736f828379711f89e8b0e621fe4bf"
    sha256 cellar: :any,                 x86_64_linux:  "c94e3aaf77fc751b7ffaf2d42d663f7afcaf3f11843c178572925a4f087930ac"
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
