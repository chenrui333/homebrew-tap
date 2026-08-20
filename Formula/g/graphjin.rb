class Graphjin < Formula
  desc "Build NodeJS / GO APIs in 5 minutes not weeks"
  homepage "https://graphjin.com/"
  url "https://github.com/dosco/graphjin/archive/refs/tags/v3.20.33.tar.gz"
  sha256 "88769c66ca6cdded24ee1ac2737867172e64932f62b2b84b119e3b12d32b1e6a"
  license "Apache-2.0"
  head "https://github.com/dosco/graphjin.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8975e20c3581fa08c62988848a7f01aad379b71d6aa468b73f146cd71b023b65"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "99ad40270c68f61c6a93e17908b96e2f9bdff4d165bc9320a6e3935ee56d0bd8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5827abf153347f2f1b586a9c9e5b8e2dbd7c89fcf125f22f49ef71fefd4385dd"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3b459b7dfbd98cfeea4e1f670e5424095dc66ee5fdd4ca52306a6c493770a92d"
    sha256 cellar: :any,                 x86_64_linux:  "154feb641079cb638f0364a33fa0196168f2f094be8dab04f539deb58e460b87"
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
