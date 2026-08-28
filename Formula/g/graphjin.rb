class Graphjin < Formula
  desc "Build NodeJS / GO APIs in 5 minutes not weeks"
  homepage "https://graphjin.com/"
  url "https://github.com/dosco/graphjin/archive/refs/tags/v3.20.65.tar.gz"
  sha256 "cf2dfcc3cb4bd8b318e3e0e23525b07e9b36e662215f180cc285cc489fae637c"
  license "Apache-2.0"
  head "https://github.com/dosco/graphjin.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ea10697dc40b33fac56248148113a6641560b7f0ab14d87e698c4d2554407f7d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "44c18036e104eeb4df6ed7e3e3b514444d3066df7f02476226f9d314ea5b7fc1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "717d3275549c68341db267fc215a7319e5017b44be81dd21cd16840b1738aa61"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1e9b77d1d803fc4724358141e88ef1e7f3cd865225ec66ca2c4cdc41758efe3a"
    sha256 cellar: :any,                 x86_64_linux:  "70a88046c8941c70222f052c585acff3726664bd63ad88ad07d4d398cd04f64b"
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
