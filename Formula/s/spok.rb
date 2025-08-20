class Spok < Formula
  desc "Lightweight build system and command runner"
  homepage "https://followtheprocess.github.io/spok/"
  url "https://github.com/FollowTheProcess/spok/archive/refs/tags/v0.8.1.tar.gz"
  sha256 "4db1d868c9f7f70684aae4ab7c6e3195afa072f28fdd70656c69ee64a8cbcef7"
  license "Apache-2.0"
  head "https://github.com/FollowTheProcess/spok.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7da0175cd0c90f7f20dc3ff04b7f7a3664f2a074fabcb3f468a14426e38705b6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "730d448acb4db941862c0842a88bc4dffe0af6be0cc759a2a8ea18439b36dc75"
    sha256 cellar: :any_skip_relocation, ventura:       "55d4bb06ea3f08a06b8ab31404c8ba84a81a3e2aff49a228de447f13e8228afe"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a5715fa1293b987d6fe05e1cbdbde4f70bb609634a4d3bdeb8d47dff25c134ae"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X go.followtheprocess.codes/spok/cli/cmd.version=#{version}
      -X go.followtheprocess.codes/spok/cli/cmd.commit=#{tap.user}
      -X go.followtheprocess.codes/spok/cli/cmd.buildDate=#{time.iso8601}
    ]
    system "go", "build", *std_go_args(ldflags:), "./cmd/spok"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/spok --version 2>&1")

    system bin/"spok", "--init"
    assert_path_exists "spokfile"
    rm "spokfile"

    test_spokfile = testpath/"spokfile"
    test_spokfile.write <<~EOS
      task default() {
        echo "Hello, Spok!"
      }
    EOS

    assert_match "Hello, Spok!", shell_output("#{bin}/spok --spokfile #{test_spokfile}")
  end
end
