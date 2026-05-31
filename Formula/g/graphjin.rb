class Graphjin < Formula
  desc "Build NodeJS / GO APIs in 5 minutes not weeks"
  homepage "https://graphjin.com/"
  url "https://github.com/dosco/graphjin/archive/refs/tags/v3.18.31.tar.gz"
  sha256 "3bccc32c7d32fd4512eeb56f07c0422d6499d57356ea1c406bec6d16e44a6be4"
  license "Apache-2.0"
  head "https://github.com/dosco/graphjin.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f99639f4f5eb2341c4ca784a6906e47b4dc4e2fc906fd7caa761fb929c31aba5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "04314808f03b6102a3d9b9827ef4c3c40d1935575e6d32eaf3908b918546e1db"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "20bb514211a671d197fe26e0c893cec8f5e375cf7f03c6fd19422f9867c98975"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d000c019e39050c6080dd432db715c45f390d0824ba0c90f6d00f596235e9a43"
    sha256 cellar: :any,                 x86_64_linux:  "91419e071c6b8cb38998d1c46ad7f59810eed260096cd2c8a11ba4b391946e59"
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
