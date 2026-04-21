class Graphjin < Formula
  desc "Build NodeJS / GO APIs in 5 minutes not weeks"
  homepage "https://graphjin.com/"
  url "https://github.com/dosco/graphjin/archive/refs/tags/v3.18.3.tar.gz"
  sha256 "36e5d238e4e25baaf56465f845db4e7fe124bf992e65183d05ce442fcacdbcde"
  license "Apache-2.0"
  head "https://github.com/dosco/graphjin.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ad47ee9386c275ff481f6475f7d3ac0571ffd65f26bf39239dcaca5ee103979a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fbb89db74d54e4c025e28a74da932ada1c4fb4222b9a40735f393116da0be358"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a663496acf552907aab37161fee7da412adcc1b211b499e04a9d044575f3a174"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e71973fe1746186114cd9ec7f5a56f2062a51a96210e54fe8c758097710682e7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ccda6b37de789a43bffb474bb1414c95c1075f3d8c3f20a25d112847390d19bf"
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
