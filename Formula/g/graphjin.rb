class Graphjin < Formula
  desc "Build NodeJS / GO APIs in 5 minutes not weeks"
  homepage "https://graphjin.com/"
  url "https://github.com/dosco/graphjin/archive/refs/tags/v3.20.38.tar.gz"
  sha256 "4550d20c926acc67c1750938a7be5e2e7005ad04e66afecfe694926024c0ff52"
  license "Apache-2.0"
  head "https://github.com/dosco/graphjin.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "652983696a1ee78a0a58e1715b83628be5d1dcf9945cd4b60702b5bab9f3f62a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c63b5ccf46ff029d2fba77407fb24d47e4930e3c202d54cc1212202c27ab1189"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "90a64d107ccc40e572094b60778afa614319a9e0e7e3cbaa9fb9e5003572187e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f0b6d868763149c598e266865418fcd23e7c3e413f276fbbb849494905cc703f"
    sha256 cellar: :any,                 x86_64_linux:  "87c89fc104d8eba70bf4905fcf65396451b597e44ff33dc402e744335035e172"
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
