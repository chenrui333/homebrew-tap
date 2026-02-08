class Graphjin < Formula
  desc "Build NodeJS / GO APIs in 5 minutes not weeks"
  homepage "https://graphjin.com/"
  url "https://github.com/dosco/graphjin/archive/refs/tags/v3.3.4.tar.gz"
  sha256 "73002f44ddd8b2d79a49668bb2990b3d4fed365074f435dbc6234c15626d81a4"
  license "Apache-2.0"
  head "https://github.com/dosco/graphjin.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9a934933e75709632911f0880176667d7efce9cddbe47698d509eeb9ee346b1c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "eaa0cdb4505f78314c86b9ee69fd33af6750601105e4d59a14a7604f4934aca6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9677c4519b9298b6e4d2bbf507210eabfbac8aa1f80d7ef67aa85795746282db"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "503c4eaadf5fe56aa2a21e172e977dca7f4ccd4c655661efbe06005aa450c038"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1c028b5fd13d11801cee309603212f4e8879d13d9bab419493aca7b28428a3d4"
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
