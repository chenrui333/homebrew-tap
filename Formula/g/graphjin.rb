class Graphjin < Formula
  desc "Build NodeJS / GO APIs in 5 minutes not weeks"
  homepage "https://graphjin.com/"
  url "https://github.com/dosco/graphjin/archive/refs/tags/v3.20.33.tar.gz"
  sha256 "88769c66ca6cdded24ee1ac2737867172e64932f62b2b84b119e3b12d32b1e6a"
  license "Apache-2.0"
  head "https://github.com/dosco/graphjin.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6daaf9a6f160014db5a5799b843599ead78298a4e7baf25dfadc5ff98d6de288"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d4c15934025f147304980ab9314f1d124af70e3fa9b803334404ff719adedb18"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "55b3ac002a26d39df093884a2712cfcba29c8d1472ed4482844e20f0084471af"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "02e7b3b608529c01934ab7c50adad47c7d15b759ff6c3e1f0a27b6653afad9b9"
    sha256 cellar: :any,                 x86_64_linux:  "4dca664fb31f06de36400a89b302d69bc018c808f559b0ced038523a4bee2ff3"
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
