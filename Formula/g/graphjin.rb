class Graphjin < Formula
  desc "Build NodeJS / GO APIs in 5 minutes not weeks"
  homepage "https://graphjin.com/"
  url "https://github.com/dosco/graphjin/archive/refs/tags/v3.20.23.tar.gz"
  sha256 "4f12118f01842641e4a4ab1ef2ae96e4ea6c996f694df27538c672b8dfd04e9f"
  license "Apache-2.0"
  head "https://github.com/dosco/graphjin.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "77cf020f28962aef6c4786958971524d9e475aa26fe20735af646524e84f1cc0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "75cb09ef69a2b65ab9cdd731ffc0dc59abed05f7592faee4142605a7d999161b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d154bfff41c6639ca4bfccdf2e3dc14645d308c8222ff69287fb72e4c8845544"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "800b86693350418e4fb4da2dc8d6f6605cbdd1d021af702169dbd9ad393f160e"
    sha256 cellar: :any,                 x86_64_linux:  "e2fe11aece5cf7c1701a65edd76d34015c39d57effb67058df1a113975a8e91e"
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
