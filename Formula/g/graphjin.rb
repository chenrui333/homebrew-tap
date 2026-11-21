class Graphjin < Formula
  desc "Build NodeJS / GO APIs in 5 minutes not weeks"
  homepage "https://graphjin.com/"
  url "https://github.com/dosco/graphjin/archive/refs/tags/v3.21.22.tar.gz"
  sha256 "ba7d66bd0d2dbcac24a4ab04d33350561519d88b444634c5b7c66f15832734e2"
  license "Apache-2.0"
  head "https://github.com/dosco/graphjin.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "22366f086847ff09cfbd2b37213aa293c48cb6002726b77b55b06e966ce396c7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0eaf42cd0c944199df6052f54021d39639f17b62efa6a1e3284a53763d654a83"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "98ecd5e810249f92199511a1aa892f365bfc8d301144d9c86cf4bcafbdfc1f32"
    sha256 cellar: :any,                 x86_64_linux:  "4fb7eb497c178025d141eb94d5054139569f8822beba07e873923b354f612ce4"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    cd "cmd" do
      system "go", "mod", "download"
    end
  end

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
