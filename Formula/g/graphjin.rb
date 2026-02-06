class Graphjin < Formula
  desc "Build NodeJS / GO APIs in 5 minutes not weeks"
  homepage "https://graphjin.com/"
  url "https://github.com/dosco/graphjin/archive/refs/tags/v3.3.0.tar.gz"
  sha256 "ebee59df9f9ace1a1e12dfd47e24fb1b3b1cc6c80cc415696dad764b7556844e"
  license "Apache-2.0"
  head "https://github.com/dosco/graphjin.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "eb3d3f6b147b427e5bc554d2898ebc137a9ab0e24c396cf55a2db6d513b365f4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f6ec3bd8546c71e8d1c1fe5d3fc37f181c0d00916e560a4f8f1eb182a64f911e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c1a11b76f6f52116418a6f0d22aebc8ba50b84e8febfb3d3f43a896652e4a229"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4853750f6902c069418222e3c56487c1054f079b2d153b6bd2e9c23a6ddabe73"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "adeb1d7683b983e8a82ed2fa89989ffd617ae6ec9126dd0a5aa0d84363d97d1f"
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
